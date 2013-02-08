# encoding: UTF-8
module OmniSearch::Engines

  # a more complicated scoring system
  class StringDistance < Base
    OUT_OF_ORDER_PENALTY = 0.001
    OVERLENGTH_PENALTY   = 0.001
    OFFSET_PENALTY       = 0.3
    ANCESTOR_SCORE        = 0.2
    BASE_SCORE           = 1
    NULL_SCORE           = 0


    def score(item)
      list_item = item[:value].downcase.strip
      search_string = @term.downcase

      return NULL_SCORE if list_item == ""
      list_words     = list_item.split(" ")
      search_words = search_string.split(" ")

      my_scores = []
      search_words.each_with_index do |string_word, i|
        search_word_score = NULL_SCORE
        list_words.each_with_index do |item_word, j|
          score = word_score(string_word, item_word)
          score -= word_position_penalty(i, j)
          search_word_score = [search_word_score, score].max
        end
        my_scores << search_word_score

      end
      score_sum = my_scores.inject(:+)
      return NULL_SCORE if my_scores.length == 0
      score_sum / search_words.length
    end

    def word_position_penalty(search_word_position, list_item_word_position)
      diff = (search_word_position - list_item_word_position).abs
      penalty = OUT_OF_ORDER_PENALTY * diff
      penalty
    end

    def overlength_penalty(search_word, list_word)
      diff = list_word.length - search_word.length
      penalty = OVERLENGTH_PENALTY * diff
      penalty
    end

    def offset_penalty(index)
      penalty = OFFSET_PENALTY * index
      penalty
    end

    def ancestor_score(search_word, item_word)
      sub_word = search_word.dup()
      chops = 0
      while sub_word do
        sub_word.chop!
        chops += 1
        break if sub_word == item_word[0..sub_word.length - 1]
        return NULL_SCORE if sub_word == ""
      end

      score = ANCESTOR_SCORE
      score = score / chops
      score
    end

    def word_score(search_word, item_word)
      index = item_word.index(search_word)
      first_letter_match = (search_word[0] == item_word[0])

      if (index == nil) && first_letter_match
        return ancestor_score(search_word, item_word)
      elsif index == nil
        return NULL_SCORE
      else
        score = BASE_SCORE
        score -= offset_penalty(index)
        score -= overlength_penalty(search_word, item_word) if index
      end
      score
    end
  end

end
