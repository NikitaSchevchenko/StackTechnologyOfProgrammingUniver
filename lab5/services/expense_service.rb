require "date"
require_relative "../models/expense"
require_relative "../errors/validation_error"

class ExpenseService
  def initialize(expenses)
    @expenses = expenses
  end

  def add(date, amount_in_kopecks, category, description)
    expense = Expense.new(
      next_id,
      date,
      amount_in_kopecks,
      category,
      description
    )

    @expenses << expense

    expense
  end

  def import(expense)
    id = if find(expense.id)
           next_id
         else
           expense.id
         end

    imported_expense = Expense.new(
      id,
      expense.date,
      expense.amount_in_kopecks,
      expense.category,
      expense.description
    )

    @expenses << imported_expense

    imported_expense
  end

  def restore(expense)
    @expenses << expense
  end

  def all
    @expenses
  end

  def sorted
    @expenses.sort_by do |expense|
      [
        expense.date,
        expense.id
      ]
    end
  end

  def find(id)
    @expenses.find do |expense|
      expense.id == id
    end
  end

  def delete(id)
    expense = find(id)

    return nil unless expense

    @expenses.delete(expense)

    expense
  end

  def filter_by_category(category)
    unless Expense::CATEGORIES.include?(category)
      raise ValidationError, "Невідома категорія"
    end

    @expenses.select do |expense|
      expense.category == category
    end
  end

  def filter_by_period(start_date, end_date)
    start_date = parse_date(start_date)
    end_date = parse_date(end_date)

    if start_date > end_date
      raise ValidationError,
            "Початкова дата не може бути пізніше кінцевої"
    end

    @expenses.select do |expense|
      expense.date >= start_date &&
        expense.date <= end_date
    end
  end

  private

  def next_id
     # Пошук першого вільного ID, який не використовується витратами
    existing_ids = @expenses.map(&:id)

    id = 1
    id += 1 while existing_ids.include?(id)

    id
  end

  def parse_date(date)
    unless date.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      raise ValidationError,
            "Дата повинна бути у форматі YYYY-MM-DD"
    end

    Date.parse(date.to_s)

  rescue Date::Error
    raise ValidationError,
          "Такої дати не існує"
  end
end
