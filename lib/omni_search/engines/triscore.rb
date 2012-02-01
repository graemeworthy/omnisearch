# encoding: UTF-8
module OmniSearch::Engines

  # a scoring system devised to match
  # the incidence of 'trigrams' sequences of three letters
  # doggie has a few
  # dog ogg ggi gie
  #
  class Triscore < Base
    def score_list
      results = []

      matches.each do |match|
        score = match_score(match)
        indexed_item  = indexed_item(match)
        next if score < @cutoff

        results << Result.new(indexed_item.merge({:score => score}) )
      end

      results.compact
    end

    def matches
      @matches ||= Trigram.search(@list, @term)
    end

    def indexed_set
      Indexes::Fetcher.new(@backmap, Indexes::Plaintext).records
    end

    def term_length
      @term_length ||= calc_term_length
    end

    def calc_term_length
      grams = Set.new
      @term.split.each do |word|
        (0..word.length - 3).each do |idx|
          grams.add(word[idx, 3])
        end
      end
      grams.length
    end

    def match_score(match)
      match_count   = match[1]
      score = (match_count.to_f / term_length)
    end

    def indexed_item(match)
      match_pointer = match[0]
      indexed_set.at(match_pointer)
    end
  end
end
