require "date"
require_relative "../app/expense_tracker"
require_relative "../errors/storage_error"
require_relative "../errors/validation_error"

class Menu
  def initialize
    @tracker = ExpenseTracker.new("expenses.json")
  rescue StorageError => e
    puts "Помилка завантаження: #{e.message}"
    exit
  end

  def start
    loop do
      show_menu

      choice = gets.chomp

      case choice
      when "1"
        add_expense
      when "2"
        show_expenses(@tracker.expenses)
      when "3"
        filter_expenses
      when "4"
        delete_expense
      when "5"
        show_statistics
      when "6"
        import_expenses
      when "7"
        puts "До побачення"
        break
      else
        puts "Невідома команда"
      end
    end
  end

  private

  def show_menu
    puts
    puts "===== Expense Tracker ====="
    puts "1. Додати витрату"
    puts "2. Переглянути всі витрати"
    puts "3. Фільтрація"
    puts "4. Видалити витрату"
    puts "5. Статистика"
    puts "6. Імпорт з JSON"
    puts "7. Вихід"
    print "Ваш вибір: "
  end

  def add_expense
    print "Дата (YYYY-MM-DD): "
    date = gets.chomp

    print "Сума в копійках: "
    amount = Integer(gets.chomp)

    print "Категорія: "
    category = gets.chomp

    print "Опис: "
    description = gets.chomp

    expense = @tracker.add(
      date,
      amount,
      category,
      description
    )

    puts "Додано витрату з ID #{expense.id}"

  rescue ArgumentError
    puts "Сума повинна бути цілим числом"
  rescue ValidationError, StorageError => e
    puts "Помилка: #{e.message}"
  end

  def show_expenses(expenses)
    if expenses.empty?
      puts "Витрат немає"
      return
    end

    puts
    puts "ID | Дата | Сума | Категорія | Опис"

    expenses.each do |expense|
      puts "#{expense.id} | #{expense.date} | #{format_money(expense.amount_in_kopecks)} | #{expense.category} | #{expense.description}"
    end
  end

  def filter_expenses
    puts "1. За категорією"
    puts "2. За періодом"

    choice = gets.chomp

    case choice
    when "1"
      print "Категорія: "
      category = gets.chomp

      show_expenses(
        @tracker.filter_by_category(category)
      )

    when "2"
      print "Початкова дата: "
      start_date = gets.chomp

      print "Кінцева дата: "
      end_date = gets.chomp

      show_expenses(
        @tracker.filter_by_period(
          start_date,
          end_date
        )
      )

    else
      puts "Невірна команда"
    end

  rescue ValidationError => e
    puts "Помилка: #{e.message}"
  end

  def delete_expense
    print "ID витрати: "
    id = Integer(gets.chomp)

    expense = @tracker.find(id)

    unless expense
      puts "Витрату не знайдено"
      return
    end

    puts "Видалити #{expense.description}? (y/n)"
    answer = gets.chomp

    if answer == "y"
      @tracker.delete(id)
      puts "Видалено"
    else
      puts "Скасовано"
    end

  rescue ArgumentError
    puts "ID повинен бути числом"
  rescue StorageError => e
    puts "Помилка збереження: #{e.message}"
  end

  def show_statistics
    statistics = @tracker.statistics

    puts
    puts "Загальна сума:"
    puts format_money(statistics.total)

    puts
    puts "По категоріях:"

    statistics.by_category.each do |category, amount|
      puts "#{category}: #{format_money(amount)}"
    end

    puts
    puts "Найбільші витрати:"

    biggest = statistics.biggest

    if biggest.empty?
      puts "Витрат немає"
    else
      biggest.each do |expense|
        puts "#{expense.description} - #{format_money(expense.amount_in_kopecks)}"
      end
    end

    show_period_statistics
  end

  def show_period_statistics
    puts
    puts "Сума за період"

    print "Початкова дата: "
    start_date = Date.parse(gets.chomp)

    print "Кінцева дата: "
    end_date = Date.parse(gets.chomp)

    if start_date > end_date
      puts "Початкова дата не може бути пізніше кінцевої"
      return
    end

    amount = @tracker.statistics.total_by_period(
      start_date,
      end_date
    )

    puts "Сума за період: #{format_money(amount)}"

  rescue Date::Error
    puts "Невірна дата"
  end

  def import_expenses
    print "Шлях до JSON файлу: "
    path = gets.chomp

    @tracker.import(path)

    puts "Імпорт успішний"

  rescue StorageError => e
    puts "Помилка імпорту: #{e.message}"
  end

  def format_money(amount)
    format("%.2f грн", amount / 100.0)
  end
end
