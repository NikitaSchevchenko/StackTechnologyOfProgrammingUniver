require_relative "ship"

module SeaBattle
  class ShipGenerator

    SHIPS = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]


    def initialize(board)
      @board = board
    end


    def generate
      SHIPS.each do |size|
        create_ship(size)
      end
    end


    private


    def create_ship(size)
      ship = Ship.new(size)

      loop do
        coordinates = generate_coordinates(size)

        if @board.can_place_ship?(coordinates)
          @board.place_ship(ship, coordinates)
          break
        end
      end
    end


    def generate_coordinates(size)
      direction = rand(2)


      if direction == 0
        row = rand(Board::SIZE)
        column = rand(Board::SIZE - size + 1)

      else
        row = rand(Board::SIZE - size + 1)
        column = rand(Board::SIZE)
      end


      coordinates = []


      size.times do |index|

        if direction == 0
          coordinates << [row, column + index]

        else
          coordinates << [row + index, column]
        end

      end


      coordinates
    end

  end
end