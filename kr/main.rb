require "csv"
require "json"
require "fileutils"

def parse_valid_score(raw_score)
  score = Integer(raw_score.to_s.strip, 10)
  return score if score.between?(0, 100)

  nil
rescue ArgumentError, TypeError
  nil
end

def build_report(input_path)
  total = 0
  valid_scores = []
  invalid_rows = []

  CSV.foreach(input_path, headers: true).with_index(1) do |row, row_number|
    total += 1
    score = parse_valid_score(row["score"])

    if score
      valid_scores << score
    else
      invalid_rows << row_number
    end
  end

  valid_count = valid_scores.size
  average = valid_count.zero? ? 0.0 : (valid_scores.sum.to_f / valid_count).round(1)
  passed = valid_scores.count { |s| s >= 60 }

  {
    total: total,
    valid: valid_count,
    invalid_rows: invalid_rows,
    average: average,
    passed: passed
  }
end


def save_report(output_path, report_data)
  FileUtils.mkdir_p(File.dirname(output_path))
  File.write(output_path, JSON.pretty_generate(report_data) + "\n")
end

def run
  input_path = File.join(__dir__, "data", "students.csv")
  output_path = File.join(__dir__, "output", "report.json")

  report = build_report(input_path)
  save_report(output_path, report)
rescue Errno::ENOENT
  warn "Помилка: вхідний файл не знайдено за шляхом #{input_path}"
  exit(1)
end

run 
