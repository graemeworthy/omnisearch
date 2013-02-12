# encoding: UTF-8

module OmniSearch
  # a more complicated scoring system
  # measures the edit distance between a pair of strings
  #
  # Usage:
  #   StringDistance.score('a string', 'another string')
  #
  class StringDistance
    OUT_OF_ORDER_PENALTY = 0.001
    OVERLENGTH_PENALTY   = 0.001
    OFFSET_PENALTY       = 0.3
    ANCESTOR_SCORE       = 0.2
    BASE_SCORE           = 1
    NULL_SCORE           = 0


    attr_reader :query
    attr_reader :reference

    def initialize(query, reference)
      @query = clean_string(query)
      @reference = clean_string(reference)
    end

    def self.score(query, reference)
      instance = self.new(query, reference)
      instance.score
    end

    # stripped and downcased, for better splitting and comparing
    def clean_string(input)
      input.downcase.strip
    end

    # the query, but split into an array
    def query_words
      @query_array ||= @query.split(' ')
    end

    # the reference, but split into an array
    def reference_words
      @reference_array ||= @reference.split(' ')
    end

    # Internal: uses WordDistance to calculate a score for a word
    # Returns a number for a score.
    def word_score(query_word, reference_word)
      WordDistance.score(query_word, reference_word)
    end


    # Public: compares every word, then creates a score for the whole string.
    # Returns a number for a score
    def score

      return NULL_SCORE if query_words.empty?
      return NULL_SCORE if reference_words.empty?
      my_scores = []

      query_words.each_with_index do |query_word, i|
        query_word_best_score = NULL_SCORE
        reference_words.each_with_index do |reference_word, j|
          score = word_score(query_word, reference_word)
          score -= word_position_penalty(i, j)
          query_word_best_score = [query_word_best_score, score].max
        end
        my_scores << query_word_best_score
      end

      return NULL_SCORE if my_scores.empty?
      score_sum   = my_scores.inject(:+)
      final_score = score_sum / query_words.length
      return final_score
    end


    # Internal: Calculate a penality for being in a different position than
    # another word so that a perfect match, but offset by one word is scored
    # less than a perfect match in the same position
    #
    # query_word_position     -  Integer
    # reference_word_position -  Integer
    #
    # Examples
    #
    # word_position_penalty(2, 1) # => 0.001
    # word_position_penalty(1, 1) # => 0
    # word_position_penalty(1, 2) # => 0.001
    # word_position_penalty(1, 3) # => 0.002
    #
    # Returns the penalty as a float.
    #
    def word_position_penalty(query_word_position, reference_word_position)
      diff = (query_word_position - reference_word_position).abs
      penalty = OUT_OF_ORDER_PENALTY * diff
      penalty
    end

  end
end


