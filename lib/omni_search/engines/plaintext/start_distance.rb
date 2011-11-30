module OmniSearch::Engines

class StartDistance < Plaintext::Base
  def cutoff
    0.1
  end

  def score(item)
    return 0 if item == ""
    list_item = item.downcase
    list_item_words = list_item.split(" ")
    search_string = @string.downcase
    search_string_words = @string.split(" ")
    my_scores = search_string_words.collect{|ss|
        scores = score_words(list_item_words, ss)
        scores.sort.pop
    }
       score_sum = my_scores.inject(:+)
       score_sum / my_scores.length
  end

  def score_words(item_words, string_word)
    item_words.collect do |word, i|
      word_score(string_word, word)
    end
  end

  def overlength_penalty(search_word, list_word)
    penalty = 0.01 * (list_word.length - search_word.length)
    penalty
  end

  def offset_penalty(search_word, list_word)
    index = list_word.index(search_word)
    return 0 if index == nil
    penalty = 0.001 * index
    penalty
  end

  def word_score(search_word, list_word)
    index = list_word.index(search_word)

    score = index ? 1 : 0
    score -= offset_penalty(search_word, list_word)
    score -= overlength_penalty(search_word, list_word) if index
    score
  end
end

end