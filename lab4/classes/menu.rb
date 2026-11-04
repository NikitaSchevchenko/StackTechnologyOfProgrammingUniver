require_relative "game"
require_relative "statistics"

module SeaBattle
  class Menu
    def initialize
      @statistics = Statistics.new
    end

    def show
      loop do
        puts "\n=== Морський бій ==="
        puts "1. Нова гра"
        puts "2. Правила"
        puts "3. Статистика"
        puts "4. Вихід"

        print "Ваш вибір: "

        choice = gets.to_i

        case choice
        when 1
          start_game
        when 2
          show_rules
        when 3
          @statistics.show
        when 4
          puts "До побачення!"
          break
        else
          puts "Невірний вибір"
        end
      end
    end

    private

    def start_game
      result = Game.new.start

      if result == :win
        @statistics.add_win
      else
        @statistics.add_loss
      end
    end

    def show_rules
      puts "\nПравила:"
      puts "1. Поле має розмір 10x10."
      puts "2. Потрібно знищити всі кораблі суперника."
      puts "3. Кораблі не можуть торкатися."
      puts "4. Вводьте координати від 0 до 9."
    end
  end
end