module OmniSearch
  # Usage
  # -------------------------------------
  # OmniSearch::Search.find('term')
  # returns a Results object
  # if it finds a synonym, that is substituted for term
  # if it finds a 'perfect' match, the intellegent results are also returned
  class Search

    attr_accessor :original
    attr_accessor :term
    attr_accessor :correction
    attr_accessor :result_sets
    attr_accessor :extended_result_sets

    def initialize(term)
      @original = term
      @term     = term
      @result_sets = []
      @extended_result_sets = []

      auto_correct
      build_results
    end

    protected

    def auto_correct
      @correction = AutoCorrect.for(@original)
      @term       = @correction.replacement if @correction
    end

    def build_results
      @result_sets          = Search::Strategy.run(@term)
      return if @result_sets == []
      @extended_result_sets = ResultSet::Extended.find(@result_sets)
      @top                  = ResultSet::Top.find(@result_sets)
      @result_sets.unshift @top
    end
  end

  class Search::Strategy

    def self.run(term)
      results = ResultSet::Factory.sets(Indexes::Plaintext, Engines::Regex, term, 0)
      if results == []
        results = ResultSet::Factory.sets(Indexes::Plaintext, Engines::StartDistance, term, 0)
      end
      results
    end

  end
end
