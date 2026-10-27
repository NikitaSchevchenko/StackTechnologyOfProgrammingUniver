def cut_cake(cake)
  raisins_count = count_raisins(cake)

  total_area = cake.length * cake[0].length
  piece_area = total_area / raisins_count

  sizes = possible_sizes(piece_area)

  used = Array.new(cake.length) do
    Array.new(cake[0].length, false)
  end

  result = []

  solve(cake, used, sizes, result)

  result
end


def count_raisins(cake)
  count = 0

  cake.each do |row|
    row.each_char do |cell|
      count += 1 if cell == "o"
    end
  end

  count
end


def possible_sizes(area)
  sizes = []

  (1..area).each do |height|
    next unless area % height == 0

    width = area / height

    sizes << [width, height]
  end

  sizes.sort_by do |width, _height|
    -width
  end
end


def solve(cake, used, sizes, result)
  position = find_first_free_cell(used)

  # Всі клітинки вже використані
  return true if position.nil?

  row = position[0]
  col = position[1]

  sizes.each do |width, height|
    next unless valid_piece?(
      cake,
      used,
      row,
      col,
      width,
      height
    )

    mark_piece(
      used,
      row,
      col,
      width,
      height,
      true
    )

    result << build_piece(
      cake,
      row,
      col,
      width,
      height
    )

    solved = solve(
      cake,
      used,
      sizes,
      result
    )

    return true if solved


    # BACKTRACKING
    result.pop

    mark_piece(
      used,
      row,
      col,
      width,
      height,
      false
    )
  end

  false
end


def find_first_free_cell(used)
  used.each_with_index do |row, row_index|
    row.each_with_index do |cell, col_index|
      return [row_index, col_index] unless cell
    end
  end

  nil
end


def valid_piece?(cake, used, row, col, width, height)
  cake_height = cake.length
  cake_width = cake[0].length

  # Перевірка меж
  return false if row + height > cake_height
  return false if col + width > cake_width


  raisins = 0

  height.times do |r|
    width.times do |c|
      current_row = row + r
      current_col = col + c


      # Клітинка вже зайнята іншим шматком
      return false if used[current_row][current_col]


      if cake[current_row][current_col] == "o"
        raisins += 1
      end
    end
  end


  # Повинен бути рівно один ізюм
  raisins == 1
end


def mark_piece(used, row, col, width, height, value)
  height.times do |r|
    width.times do |c|
      used[row + r][col + c] = value
    end
  end
end


def build_piece(cake, row, col, width, height)
  piece = []

  height.times do |r|
    line = ""

    width.times do |c|
      line << cake[row + r][col + c]
    end

    piece << line
  end

  piece
end


# TEST 1
cake = [
  "........",
  "..o.....",
  "...o....",
  "........"
]

puts "TEST 1"
puts cut_cake(cake).inspect


# TEST 2
cake = [
  ".o......",
  "......o.",
  "....o...",
  "..o....."
]

puts "\nTEST 2"
puts cut_cake(cake).inspect


# TEST 3
cake = [
  "o.......",
  ".o......",
  "..o.....",
  "...o...."
]

puts "\nTEST 3"
puts cut_cake(cake).inspect


# TEST 4
cake = [
  ".o.o....",
  "........",
  "....o...",
  "........",
  ".....o..",
  "........"
]

puts "\nTEST 4"
puts cut_cake(cake).inspect


# TEST 5
cake = [
  "o.........",
  "..........",
  "..o.......",
  "..........",
  "....o.....",
  "..........",
  "......o...",
  ".........."
]

puts "\nTEST 5"
puts cut_cake(cake).inspect


# TEST 6
cake = [
  "..o...",
  "......",
  "..o...",
  "......",
  "..o...",
  "......"
]

puts "\nTEST 6"
puts cut_cake(cake).inspect


# TEST 7
cake = [
  "........",
  ".o......",
  "........",
  "......o.",
  "........",
  "....o...",
  "........",
  "..o....."
]

puts "\nTEST 7"
puts cut_cake(cake).inspect


# TEST 8
cake = [
  ".o........",
  "..........",
  "...o......",
  "..........",
  ".....o....",
  "..........",
  ".......o..",
  "..........",
  ".........o"
]

puts "\nTEST 8"
puts cut_cake(cake).inspect


# TEST 9
cake = [
  "o.......",
  "........",
  "....o...",
  "........",
  ".......o",
  "........"
]

puts "\nTEST 9"
puts cut_cake(cake).inspect

