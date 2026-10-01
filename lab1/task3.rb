def play_round(user, computer)
  if user == computer
    puts "Нічия!"
    return :draw

  elsif (user == "Камінь" && computer == "Ножиці") ||
        (user == "Ножиці" && computer == "Папір") ||
        (user == "Папір" && computer == "Камінь")

    puts "Ви перемогли!"
    return :user

  else
    puts "Комп'ютер переміг!"
    return :computer
  end
end


choices = ["Камінь", "Ножиці", "Папір"]

user_wins = 0
computer_wins = 0
draws = 0
rounds = 0


loop do
  print "Ваш вибір: "
  user = gets.strip

  computer = choices.sample

  puts "Вибір комп'ютера: #{computer}"


  result = play_round(user, computer)

  rounds += 1


  if result == :user
    user_wins += 1

  elsif result == :computer
    computer_wins += 1

  else
    draws += 1
  end


  puts "Перемог користувача: #{user_wins}"
  puts "Перемог комп'ютера: #{computer_wins}"
  puts "Нічиїх: #{draws}"
  puts "Всього раундів: #{rounds}"

  puts "----------------"
end