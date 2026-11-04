require "set"

module SeaBattle
  class ComputerPlayer
    def initialize
      @shots = Set.new
    end

    def make_shot
      loop do
        coordinate = [
          rand(Board::SIZE),
          rand(Board::SIZE)
        ]

        unless @shots.include?(coordinate)
          @shots.add(coordinate)
          return coordinate
        end
      end
    end
  end
end