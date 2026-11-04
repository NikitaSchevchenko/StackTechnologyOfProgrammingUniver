require_relative "board"
require_relative "ship_generator"
require_relative "errors"
require_relative "computer_player"

module SeaBattle
  class Game
    def initialize
      @player_board = Board.new
      @computer_board = Board.new
      @computer_player = ComputerPlayer.new
    end

    def start
      setup_boards
      game_loop
    end

    private

    def setup_boards
      ShipGenerator.new(@player_board).generate
      ShipGenerator.new(@computer_board).generate
    end

    def game_loop
      loop do
        player_turn

        if @computer_board.all_ships_destroyed?
          puts "Ви перемогли!"
          return :win
        end

        computer_turn

        if @player_board.all_ships_destroyed?
          puts "Комп'ютер переміг!"
          return :loss
        end
      end
    end

    def player_turn
      puts "\nВаше поле:"
      @player_board.display(true)

      puts "\nПоле противника:"
      @computer_board.display

      puts "\nВаш хід"

      loop do
        coordinate = get_coordinate
        result = @computer_board.shoot(coordinate)

        puts result

        break unless result == "Ви вже стріляли сюди"
      end

    rescue InputError => error
      puts error.message
      retry
    end

    def computer_turn
      coordinate = @computer_player.make_shot

      puts "\nКомп'ютер стріляє: #{coordinate}"

      result = @player_board.shoot(coordinate)

      puts result
    end

    def get_coordinate
      print "Введіть рядок: "
      row = gets.chomp

      print "Введіть колонку: "
      column = gets.chomp

      unless valid_coordinate?(row, column)
        raise InputError, "Координати повинні бути числами від 0 до 9"
      end

      [row.to_i, column.to_i]
    end

    def valid_coordinate?(row, column)
      return false unless row.match?(/^\d+$/) && column.match?(/^\d+$/)

      row.to_i.between?(0, 9) &&
        column.to_i.between?(0, 9)
    end
  end
end