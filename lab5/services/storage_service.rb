require "json"
require_relative "../models/expense"
require_relative "../errors/storage_error"
require_relative "../errors/validation_error"

class StorageService
  def initialize(file_path)
    @file_path = file_path
  end

  def load
    return [] unless File.exist?(@file_path)

    content = File.read(@file_path)

    raise StorageError, "Файл порожній" if content.strip.empty?

    data = JSON.parse(content)

    unless data.is_a?(Array)
      raise StorageError, "JSON повинен містити список витрат"
    end

    data.map do |expense|
      Expense.new(
        expense["id"],
        expense["date"],
        expense["amount_in_kopecks"],
        expense["category"],
        expense["description"]
      )
    end

  rescue JSON::ParserError => e
    raise StorageError, "JSON файл пошкоджений: #{e.message}"

  rescue ValidationError => e
    raise StorageError, "Некоректний запис: #{e.message}"
  end

  def save(expenses)
    data = expenses.map(&:to_hash)

    json = JSON.pretty_generate(data)

    temp_file = "#{@file_path}.tmp"

    begin
      File.write(temp_file, json)

      File.rename(temp_file, @file_path)

    rescue StandardError => e
      File.delete(temp_file) if File.exist?(temp_file)

      raise StorageError,
            "Не вдалося зберегти файл: #{e.message}"
    end
  end
end
