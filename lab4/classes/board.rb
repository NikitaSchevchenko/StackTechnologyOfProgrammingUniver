require_relative "errors"

module SeaBattle
  class Board

    SIZE = 10

    attr_reader :ships

    def initialize
      @cells = Array.new(SIZE) { Array.new(SIZE, "~") }
      @ships = []
    end

    def can_place_ship?(coordinates)
      coordinates.each do |coordinate|
        row = coordinate[0]
        column = coordinate[1]

        return false unless inside_board?(row, column)
        return false unless empty_area?(row, column)
      end

      true
    end

    def place_ship(ship, coordinates)
      raise ShipPlacementError, "Неможливо розмістити корабель" unless can_place_ship?(coordinates)

      coordinates.each do |coordinate|
        row = coordinate[0]
        column = coordinate[1]

        @cells[row][column] = "S"
      end

      ship.coordinates.concat(coordinates)
      @ships << ship
    end

    def shoot(coordinate)
      row = coordinate[0]
      column = coordinate[1]

      if @cells[row][column] == "X" || @cells[row][column] == "O"
        return "Ви вже стріляли сюди"
      end

      @ships.each do |ship|
        if ship.hit(coordinate)

          @cells[row][column] = "X"

          if ship.destroyed?
            return "Корабель знищено"
          else
            return "Влучання"
          end

        end
      end

      @cells[row][column] = "O"

      "Промах"
    end

    def all_ships_destroyed?
      @ships.all? do |ship|
        ship.destroyed?
      end
    end

    def display(show_ships = false)
      @cells.each do |row|
        result = row.map do |cell|

          if cell == "S" && !show_ships
            "~"
          else
            cell
          end

        end

        puts result.join(" ")
      end
    end


    private


    def inside_board?(row, column)
      row.between?(0, SIZE - 1) &&
        column.between?(0, SIZE - 1)
    end


    def empty_area?(row, column)

      (-1..1).each do |row_offset|
        (-1..1).each do |column_offset|

          new_row = row + row_offset
          new_column = column + column_offset

          next unless inside_board?(new_row, new_column)

          return false if @cells[new_row][new_column] == "S"

        end
      end

      true
    end

  end
end