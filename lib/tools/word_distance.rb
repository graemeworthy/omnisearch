# encoding: UTF-8

module OmniSearch
  # Part of calculating the String Distance
  #
  # compares two words, the query and the reference
  # returns a score based on comparing the two
  #
  # Usage:
  #   WordDistance.score('query', 'reference')
  #     # => 0.0
  #
  #   WordDistance.new('something', 'anotherthing')
  #
  class StringDistance::WordDistance
    OVERLENGTH_PENALTY   =  OmniSearch::StringDistance::OVERLENGTH_PENALTY
    OFFSET_PENALTY       =  OmniSearch::StringDistance::OFFSET_PENALTY
    ANCESTOR_SCORE       =  OmniSearch::StringDistance::ANCESTOR_SCORE
    BASE_SCORE           =  OmniSearch::StringDistance::BASE_SCORE
    NULL_SCORE           =  OmniSearch::StringDistance::NULL_SCORE
    BINGO_SCORE          =  2

    attr_reader :query
    attr_reader :reference
    # countless queries are scored against a reference
    # but the reference is itself a query
    # i need to rename some things.

    def initialize(query, reference)
      @query = query
      @reference = reference
    end

    # Public: Calculates a similarity score for two words
    # see '#word_score'
    #
    def self.score(query, reference)
      instance = self.new(query, reference)
      instance.word_score
    end

    # Public: Calculates a similarity score for two words
    # MUST NOT return a score below NULL_SCORE
    # SHOULD NOT return a score above BASE_SCORE
    #
    # Returns a numerical score
    #  should be between BASE_SCORE (match)
    #                and NULL_SCORE (no match)
    #
    def word_score
      return BINGO_SCORE if (query == reference)
      if string_index
        score = substring_score
      else
        score = ancestor_score
      end

      return NULL_SCORE if score < NULL_SCORE
      return score
    end

    # Internal: Does the first letter of query match that of the reference?
    # Returns a boolean
    def first_letter_match
      @query[0] == @reference[0]
    end

    # Internal: If query is a substring of reference, return it's offset.
    # uses String#index, and behaves accordingly.
    # Returns nil or an offset.
    def string_index
      @string_index ||= query.index(reference)
    end

    # Internal: Calcuates the query's score based on it's offset from
    # the reference.
    #
    def substring_score
      score = BASE_SCORE
      score -= offset_penalty(string_index)
      score -= overlength_penalty
      return score
    end


    # Internal: Calculate a penalty for the query word being longer than the
    # reference word.
    #
    # intent:
    #  goal: peter rabbit
    #  p
    #  pe
    #  peter
    # queries are not penalized for being shorter than the reference
    #
    # Returns a float that is the penalty score
    #
    def overlength_penalty
      diff = query.length - reference.length
      diff = 0 if (diff < 1)
      penalty = OVERLENGTH_PENALTY * diff
      return penalty
    end


    # Interal: Calculate a penalty for every letter before the match
    # Strong matches are good, but initial matches are better
    #
    # index - An integer, the position of a word in it's array
    #
    # Returns a float that is the penalty score
    #
    def offset_penalty(index)
      OFFSET_PENALTY * index || nil
    end

    # Internal: Calculates a score based on how many backspaces it would take
    # to make the query match the reference
    #
    # Example:
    #  randall, randy (one jump - the y)
    #  randall, randys (two jumps, ys)
    #
    # Returns a float that is the penalty score
    def ancestor_score
      return NULL_SCORE unless first_letter_match
      sub_word = "#{reference}" #dup
      chops = 0
      while sub_word != "" do
          chops += 1
          sub_word.chop!
          sub_ref = query[0..sub_word.length - 1]
          break if sub_word == sub_ref
      end

      score = ANCESTOR_SCORE / chops
      return score
    end
  end
end
