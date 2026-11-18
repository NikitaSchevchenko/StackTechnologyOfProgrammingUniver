require "date"
require_relative "../errors/validation_error"

class Expense
  CATEGORIES = [
    "food",
    "transport",
    "study",
    "entertainment",
    "other"
  ]

  attr_accessor :id,
                :date,
                :amount_in_kopecks,
                :category,
                :description

  def initialize(id, date, amount_in_kopecks, category, description)
    @id = id
    @date = parse_date(date)
    @amount_in_kopecks = amount_in_kopecks
    @category = category
    @description = normalize_description(description)

    validate!
  end

  # Для збереження об'єкта у JSON
  def to_hash
    {
      "id" => @id,
      "date" => @date.to_s,
      "amount_in_kopecks" => @amount_in_kopecks,
      "category" => @category,
      "description" => @description
    }
  end

  private

  def normalize_description(description)
    raise ValidationError, "Опис не може бути порожнім" if description.nil?

    description.strip
  end

  def parse_date(date)
    unless date.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      raise ValidationError,
            "Дата повинна бути у форматі YYYY-MM-DD"
    end

    Date.parse(date.to_s)

  rescue Date::Error
    raise ValidationError,
          "Такої календарної дати не існує"
  end

  def validate!
    raise ValidationError,
          "ID має бути додатним" unless @id.is_a?(Integer) && @id > 0

    raise ValidationError,
          "Сума має бути додатним числом" unless @amount_in_kopecks.is_a?(Integer) && @amount_in_kopecks > 0

    raise ValidationError,
          "Невідома категорія" unless CATEGORIES.include?(@category)

    raise ValidationError,
          "Опис не може бути порожнім" if @description.empty?

    raise ValidationError,
          "Опис занадто довгий" if @description.length > 200
  end
end
