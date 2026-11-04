module SeaBattle
  class Ship
    attr_reader :size, :coordinates

    def initialize(size)
      @size = size
      @coordinates = []
      @hits = []
    end

    def hit(coordinate)
      return false unless @coordinates.include?(coordinate)
      return false if @hits.include?(coordinate)

      @hits << coordinate
      true
    end

    def destroyed?
      @hits.length == @size
    end
  end
end