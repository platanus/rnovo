class GenerateTrademarkVariationsJob < ApplicationJob
  queue_as :default

  def perform(trademark_name)
    @trademark_name = trademark_name.downcase

    if @trademark_name.length < 3
      [@trademark_name]
    elsif splitted_name.length == 1
      variations_for_one_word
    else
      variations_for_multiple_words
    end
  end

  private

  def variations_for_one_word
    word = @trademark_name
    [
      word_without_vowels(word),
      last_letter_case(word)
    ].flatten.compact
  end

  def variations_for_multiple_words
    words = splitted_name
    [
      words.first,
      words.last,
      "#{words.first} #{words.last}"
    ].flatten.compact
  end

  def last_letter_case(word)
    return word[0..-2] if word[-1].match?(/[aeiou]/)

    %w[a e i o u].map { |ending| word + ending }
  end

  def word_without_vowels(word)
    word.gsub(/[aeiou]/, '')
  end

  def splitted_name
    @splitted_name ||= @trademark_name.split(' ')
  end
end
