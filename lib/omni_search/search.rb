# encoding: UTF-8
module OmniSearch
  # Usage
  # -------------------------------------
  # OmniSearch::Search.new('term')
  #
  # Executes Search::Strategy, and returns the results.
  #  also builds the extended results and gathers top results
  #
  # if it finds a synonym, that is substituted for term
  # if it finds a 'perfect' match, the intellegent results are also returned
  #
  #
  class Search

    attr_accessor :original
    attr_accessor :term
    attr_accessor :correction
    attr_accessor :result_sets
    attr_accessor :extended_result_sets
    attr_accessor :from_cache

    def initialize(term)
      @original = term
      @term     = term
      @result_sets = []
      @extended_result_sets = []
      @from_cache = false
      auto_correct
      build_results
    end

    def just(indexed_klass)
      @result_sets.select { |set| set.klass == indexed_klass }[0]
    end

    protected

    def auto_correct
      @correction = AutoCorrect.for(@original)
      @term       = @correction.replacement if @correction
    end

    # executes search strategy and populates local variables
    def build_results
      @result_sets          = Search::Strategy.run(@term)

      unless @result_sets.empty?
        @extended_result_sets = ResultSet::Extended.find(@result_sets)
        @top                  = ResultSet::Top.find(@result_sets)
        @result_sets.unshift @top
      end

    end
  end

end
