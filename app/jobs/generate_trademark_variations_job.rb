class GenerateTrademarkVariationsJob < ApplicationJob
  queue_as :default

  def perform(trademark_name)
    @trademark_name = trademark_name.downcase

    if @trademark_name.length < 3
      [@trademark_name]
    elsif splitted_name.length == 1
      variations_for_one_word
    elsif splitted_name.length.between?(2, 4)
      variations_for_two_to_four_words
    else
      variations_for_more_than_four_words
    end
  end

  private

  def variations_for_one_word
    word = @trademark_name
    [
      word,
      word_without_first_letter(word),
      word_without_last_letter(word),
      word_without_vowels(word),
      word_without_consonants(word)
    ]
  end

  def variations_for_two_to_four_words
    words = splitted_name

    variations = [@trademark_name, *words.dup]

    words.combination(2).each do |combination|
      variations << combination.join(' ')
    end

    variations.uniq
  end

  def variations_for_more_than_four_words
    words = splitted_name
    [
      @trademark_name,
      words.first,
      words.last,
      "#{words.first} #{words.last}"
    ]
  end

  def word_without_first_letter(word)
    word[1..]
  end

  def word_without_last_letter(word)
    word[..-2]
  end

  def word_without_vowels(word)
    word.gsub(/[aeiou]/, '')
  end

  def word_without_consonants(word)
    word.gsub(/[^aeiou]/, '')
  end

  def splitted_name
    @splitted_name ||= @trademark_name.split(' ')
  end
end
