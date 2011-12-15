module OmniSearch::Engines

  class StartDistance < Base

    def score(item)
      list_item = item[:value].downcase
      list_item.strip!
      return 0 if list_item == ""
      list_item_words = list_item.split(" ")
      search_string = @term.downcase
      search_string_words = @term.split(" ")
      my_scores = search_string_words.collect{|ss|
        scores = score_words(list_item_words, ss)
        scores.sort.pop
      }
      score_sum = my_scores.inject(:+)
      return 0 if my_scores.length == 0
      score_sum / my_scores.length
    end

    def score_words(item_words, string_word)
      item_words.collect do |word, i|
        word_score(string_word, word)
      end
    end

    def overlength_penalty(search_word, list_word)
      penalty = 0.001 * (list_word.length - search_word.length)
      penalty
    end

    def offset_penalty(search_word, list_word)
      index = list_word.index(search_word)
      return 0 if index == nil
      penalty = 0.1 * index
      penalty
    end

    def out_of_order_penalty

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
