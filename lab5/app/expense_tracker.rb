require_relative "../services/storage_service"
require_relative "../services/expense_service"
require_relative "../services/statistics_service"

class ExpenseTracker
  def initialize(file_path)
    @storage = StorageService.new(file_path)

    expenses = @storage.load

    @expense_service = ExpenseService.new(expenses)
    @statistics_service = StatisticsService.new(expenses)
  end

  def add(date, amount, category, description)
    expense = @expense_service.add(
      date,
      amount,
      category,
      description
    )

    begin
      save
    rescue StorageError => e
      @expense_service.delete(expense.id)

      raise e
    end

    expense
  end

  def expenses
    @expense_service.sorted
  end

  def filter_by_category(category)
    @expense_service.filter_by_category(category)
  end

  def filter_by_period(start_date, end_date)
    @expense_service.filter_by_period(
      start_date,
      end_date
    )
  end

  def find(id)
    @expense_service.find(id)
  end

  def delete(id)
    deleted_expense = @expense_service.delete(id)

    return false unless deleted_expense

    begin
      save
    rescue StorageError => e
      @expense_service.restore(deleted_expense)

      raise e
    end

    true
  end

  def statistics
    @statistics_service
  end

  def import(path)
    imported_expenses = StorageService.new(path).load

    added_expenses = []

    begin
      imported_expenses.each do |expense|
        added_expenses << @expense_service.import(expense)
      end

      save

    rescue StorageError => e
      added_expenses.each do |expense|
        @expense_service.delete(expense.id)
      end

      raise e
    end
  end

  private

  def save
    @storage.save(@expense_service.all)
  end
end
