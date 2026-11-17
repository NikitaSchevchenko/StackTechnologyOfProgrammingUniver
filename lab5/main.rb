require "csv"

class StudentManager
  def initialize(file_name)
    @file_name = file_name
    @students = []
    load_data
  end

  # ---------------- Зчитування ----------------

  def load_data
    begin
      unless File.exist?(@file_name)
        File.write(@file_name, "name,subject,grade\n")
      end

      @students = []

      CSV.foreach(@file_name, headers: true) do |row|
        name = row["name"]
        subject = row["subject"]
        grade = row["grade"]

        raise "Некоректний запис" if name.nil? || subject.nil? || grade.nil?

        grade = Integer(grade)

        raise "Оцінка повинна бути від 0 до 100" unless (0..100).include?(grade)

        @students << {
          name: name,
          subject: subject,
          grade: grade
        }
      end

    rescue Errno::ENOENT
      puts "Файл не знайдено."
    rescue ArgumentError
      puts "Некоректне значення оцінки."
    rescue => e
      puts "Помилка: #{e.message}"
    end
  end

  # ---------------- Збереження ----------------

  def save_data
    CSV.open(@file_name, "w") do |csv|
      csv << ["name", "subject", "grade"]

      @students.each do |student|
        csv << [
          student[:name],
          student[:subject],
          student[:grade]
        ]
      end
    end
  end

  # ---------------- Перегляд ----------------

  def show_all
    if @students.empty?
      puts "Дані відсутні."
      return
    end

    puts
    puts "Список студентів"

    @students.each_with_index do |student, index|
      puts "#{index + 1}. #{student[:name]} | #{student[:subject]} | #{student[:grade]}"
    end
  end

  # ---------------- Середній бал студентів ----------------

  def average_by_student
    groups = {}

    @students.each do |student|
      groups[student[:name]] ||= []
      groups[student[:name]] << student[:grade]
    end

    puts
    puts "Середній бал"

    groups.each do |name, grades|
      average = grades.sum.to_f / grades.size
      puts "#{name}: #{average.round(2)}"
    end
  end

  # ---------------- Найкращий та найгірший ----------------

  def best_and_worst
    groups = {}

    @students.each do |student|
      groups[student[:name]] ||= []
      groups[student[:name]] << student[:grade]
    end

    averages = {}

    groups.each do |name, grades|
      averages[name] = grades.sum.to_f / grades.size
    end

    best = averages.max_by { |_, value| value }
    worst = averages.min_by { |_, value| value }

    puts
    puts "Найкращий студент:"
    puts "#{best[0]} (#{best[1].round(2)})"

    puts
    puts "Найгірший студент:"
    puts "#{worst[0]} (#{worst[1].round(2)})"
  end

  # ---------------- Середній бал по предметах ----------------

  def average_by_subject
    groups = {}

    @students.each do |student|
      groups[student[:subject]] ||= []
      groups[student[:subject]] << student[:grade]
    end

    puts
    puts "Середній бал по предметах"

    groups.each do |subject, grades|
      average = grades.sum.to_f / grades.size
      puts "#{subject}: #{average.round(2)}"
    end
  end

  # ---------------- Пошук ----------------

  def search_student
    print "Введіть ім'я: "
    name = gets.chomp

    result = @students.select do |student|
      student[:name].downcase == name.downcase
    end

    if result.empty?
      puts "Студента не знайдено."
      return
    end

    result.each do |student|
      puts "#{student[:subject]} - #{student[:grade]}"
    end
  end

  # ---------------- Додавання ----------------

  def add_grade
    print "Ім'я: "
    name = gets.chomp

    print "Предмет: "
    subject = gets.chomp

    print "Оцінка: "
    grade = gets.chomp.to_i

    unless (0..100).include?(grade)
      puts "Некоректна оцінка."
      return
    end

    @students << {
      name: name,
      subject: subject,
      grade: grade
    }

    save_data

    puts "Запис додано."
  end

  # ---------------- Редагування ----------------

  def edit_grade
    show_all

    print "Номер запису: "
    index = gets.chomp.to_i - 1

    if index < 0 || index >= @students.size
      puts "Невірний номер."
      return
    end

    print "Нова оцінка: "
    grade = gets.chomp.to_i

    unless (0..100).include?(grade)
      puts "Некоректна оцінка."
      return
    end

    @students[index][:grade] = grade

    save_data

    puts "Оцінку змінено."
  end

  # ---------------- Видалення ----------------

  def delete_grade
    show_all

    print "Номер запису: "
    index = gets.chomp.to_i - 1

    if index < 0 || index >= @students.size
      puts "Невірний номер."
      return
    end

    @students.delete_at(index)

    save_data

    puts "Запис видалено."
  end

  # ---------------- Звіт ----------------

  def create_report
    File.open("report.txt", "w") do |file|

      groups = {}

      @students.each do |student|
        groups[student[:name]] ||= []
        groups[student[:name]] << student[:grade]
      end

      file.puts "Середній бал студентів"

      groups.each do |name, grades|
        average = grades.sum.to_f / grades.size
        file.puts "#{name}: #{average.round(2)}"
      end

      file.puts

      subjects = {}

      @students.each do |student|
        subjects[student[:subject]] ||= []
        subjects[student[:subject]] << student[:grade]
      end

      file.puts "Середній бал по предметах"

      subjects.each do |subject, grades|
        average = grades.sum.to_f / grades.size
        file.puts "#{subject}: #{average.round(2)}"
      end
    end

    puts "Файл report.txt створено."
  end

  # ---------------- Меню ----------------

  def menu
    loop do
      puts
      puts "1. Показати всі записи"
      puts "2. Середній бал студентів"
      puts "3. Найкращий та найгірший студент"
      puts "4. Середній бал по предметах"
      puts "5. Пошук студента"
      puts "6. Додати оцінку"
      puts "7. Редагувати оцінку"
      puts "8. Видалити оцінку"
      puts "9. Створити звіт"
      puts "0. Вихід"

      print "Ваш вибір: "

      choice = gets.chomp

      case choice
      when "1"
        show_all
      when "2"
        average_by_student
      when "3"
        best_and_worst
      when "4"
        average_by_subject
      when "5"
        search_student
      when "6"
        add_grade
      when "7"
        edit_grade
      when "8"
        delete_grade
      when "9"
        create_report
      when "0"
        puts "До побачення!"
        break
      else
        puts "Невірний вибір."
      end
    end
  end
end

manager = StudentManager.new("students.csv")
manager.menu
