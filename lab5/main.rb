require_relative "ui/menu"

begin
  menu = Menu.new
  menu.start

rescue StandardError => e
  puts "Критична помилка: #{e.message}"
end
