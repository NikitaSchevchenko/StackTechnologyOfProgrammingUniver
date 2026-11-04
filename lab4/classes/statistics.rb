module SeaBattle
  class Statistics
    def initialize
      @wins = 0
      @losses = 0
    end

    def add_win
      @wins += 1
    end

    def add_loss
      @losses += 1
    end

    def show
      puts "Перемоги: #{@wins}"
      puts "Поразки: #{@losses}"
    end
  end
end