def word_stats(text)
  words = text.split

  count = words.length

  longest_word = words.max_by do |word|
    word.length
  end

  unique_words = words.map do |word|
    word.downcase
  end.uniq.length

  puts "#{count} слів, найдовше: #{longest_word}, унікальних: #{unique_words}"
end


text = gets

word_stats(text)