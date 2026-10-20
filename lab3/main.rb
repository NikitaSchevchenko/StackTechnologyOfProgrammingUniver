class SudokuGame
  def initialize(size, difficulty)
    @size = size
    @block_size = Math.sqrt(size).to_i

    @moves = 0
    @mistakes = 0
    @hints = 0

    @history = []
    @start_time = Time.now

    create_board(difficulty)

    @original_board = deep_copy(@board)
  end


  def show_board
    puts "\nSudoku #{@size}x#{@size}"
    puts "-" * (@size * 2 + @block_size)

    @board.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|

        print cell.zero? ? ". " : "#{cell} "

        if (col_index + 1) % @block_size == 0 &&
           col_index != @size - 1

          print "| "
        end
      end

      puts

      if (row_index + 1) % @block_size == 0 &&
         row_index != @size - 1

        puts "-" * (@size * 2 + @block_size)
      end
    end

    puts "-" * (@size * 2 + @block_size)
  end


  def make_move(row, col, number)
    unless valid_position?(row, col)
      @mistakes += 1
      return "Невірні координати"
    end


    if fixed_cell?(row, col)
      @mistakes += 1
      return "Не можна змінювати початкове число"
    end


    unless number.between?(1, @size)
      @mistakes += 1
      return "Число повинно бути від 1 до #{@size}"
    end


    unless valid_move?(row, col, number)
      @mistakes += 1
      return "Порушення правил Sudoku"
    end


    save_history

    @board[row][col] = number
    @moves += 1

    "Хід виконано"
  end


  def undo
    return "Немає ходів для скасування" if @history.empty?

    @board = @history.pop

    "Останній хід скасовано"
  end


  def hint
    empty_cells = []


    @size.times do |row|
      @size.times do |col|

        if @board[row][col].zero?
          empty_cells << [row, col]
        end

      end
    end


    return "Поле вже заповнене" if empty_cells.empty?


    row, col = empty_cells.sample

    @hints += 1

    "Підказка: рядок #{row + 1}, стовпець #{col + 1} = #{@solution[row][col]}"
  end


  def completed?
    @board == @solution
  end


  def statistics
    time = ((Time.now - @start_time) / 60).round(2)

    puts "\nСтатистика:"
    puts "Ходів: #{@moves}"
    puts "Помилок: #{@mistakes}"
    puts "Підказок: #{@hints}"
    puts "Час гри: #{time} хв"
  end

  private


  def create_board(difficulty)
    if @size == 4

      @solution = [
        [1, 2, 3, 4],
        [3, 4, 1, 2],
        [2, 3, 4, 1],
        [4, 1, 2, 3]
      ]


      @board =
        case difficulty
        when 1
          [
            [1, 0, 0, 4],
            [0, 4, 1, 0],
            [2, 0, 4, 0],
            [0, 1, 0, 2]
          ]

        when 2
          [
            [1, 0, 0, 4],
            [0, 4, 0, 0],
            [2, 0, 4, 0],
            [0, 0, 0, 2]
          ]

        else
          [
            [0, 0, 3, 4],
            [0, 4, 0, 0],
            [2, 0, 4, 0],
            [0, 0, 0, 2]
          ]
        end

    else

      @solution = [
        [5, 3, 4, 6, 7, 8, 9, 1, 2],
        [6, 7, 2, 1, 9, 5, 3, 4, 8],
        [1, 9, 8, 3, 4, 2, 5, 6, 7],
        [8, 5, 9, 7, 6, 1, 4, 2, 3],
        [4, 2, 6, 8, 5, 3, 7, 9, 1],
        [7, 1, 3, 9, 2, 4, 8, 5, 6],
        [9, 6, 1, 5, 3, 7, 2, 8, 4],
        [2, 8, 7, 4, 1, 9, 6, 3, 5],
        [3, 4, 5, 2, 8, 6, 1, 7, 9]
      ]


      @board = deep_copy(@solution)


      remove_count =
        case difficulty
        when 1
          25
        when 2
          45
        else
          60
        end


      remove_count.times do
        row = rand(9)
        col = rand(9)

        @board[row][col] = 0
      end

    end
  end



  def valid_move?(row, col, number)
    return false if check_row(row, number)
    return false if check_column(col, number)
    return false if check_block(row, col, number)

    true
  end



  def check_row(row, number)
    @board[row].include?(number)
  end



  def check_column(col, number)
    @size.times do |row|
      return true if @board[row][col] == number
    end

    false
  end



  def check_block(row, col, number)
    start_row = (row / @block_size) * @block_size
    start_col = (col / @block_size) * @block_size


    @block_size.times do |r|
      @block_size.times do |c|

        return true if @board[start_row + r][start_col + c] == number

      end
    end


    false
  end



  def valid_position?(row, col)
    row.between?(0, @size - 1) &&
      col.between?(0, @size - 1)
  end



  def fixed_cell?(row, col)
    @original_board[row][col] != 0
  end



  def save_history
    @history << deep_copy(@board)
  end



  def deep_copy(object)
    Marshal.load(Marshal.dump(object))
  end
end

puts "Виберіть розмір Sudoku:"
puts "1 - 4x4"
puts "2 - 9x9"

size_choice = gets.to_i

size =
  if size_choice == 1
    4
  else
    9
  end



puts "\nВиберіть складність:"
puts "1 - Легка"
puts "2 - Середня"
puts "3 - Складна"

difficulty = gets.to_i



game = SudokuGame.new(size, difficulty)



loop do
  game.show_board

  puts "\nКоманди:"
  puts "1 - Зробити хід"
  puts "2 - Скасувати хід"
  puts "3 - Підказка"
  puts "4 - Вийти"


  command = gets.to_i

  case command
  when 1
    print "Рядок: "
    row = gets.to_i - 1
    print "Стовпець: "
    col = gets.to_i - 1
    print "Число: "
    number = gets.to_i

    puts game.make_move(row, col, number)

  when 2
    puts game.undo

  when 3
    puts game.hint
  when 4
    puts "Гру завершено"
    break
  else
    puts "Невідома команда"
  end

  if game.completed?
    game.show_board

    puts "\nВітаємо! Sudoku розв'язано!"

    break
  end

end


game.statistics