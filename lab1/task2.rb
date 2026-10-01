def play_game
  secret_number = rand(1..100)
  attempts = 0

  puts "Я загадав число від 1 до 100"

  loop do
    print "Введіть число: "

    guess = gets.to_i
    attempts += 1

    if guess < secret_number
      puts "більше"
    elsif guess > secret_number
      puts "менше"
    else
      puts "вгадано!"
      puts "Кількість спроб: #{attempts}"
      break
    end
  end
end


play_game