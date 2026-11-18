class StatisticsService
  def initialize(expenses)
    @expenses = expenses
  end

  def total
    @expenses.sum(&:amount_in_kopecks)
  end

  def by_category
    result = {}

    @expenses.each do |expense|
      category = expense.category

      result[category] ||= 0
      result[category] += expense.amount_in_kopecks
    end

    result
  end

  def biggest
    return [] if @expenses.empty?

    max_amount = @expenses.map(&:amount_in_kopecks).max

    @expenses.select do |expense|
      expense.amount_in_kopecks == max_amount
    end
  end

  # Сума витрат за період включно з обома датами
  def total_by_period(start_date, end_date)
    @expenses
      .select do |expense|
        expense.date >= start_date &&
          expense.date <= end_date
      end
      .sum(&:amount_in_kopecks)
  end
end
