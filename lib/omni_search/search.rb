# encoding: UTF-8
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

      unless @result_sets.empty?
        @extended_result_sets = ResultSet::Extended.find(@result_sets)
        @top                  = ResultSet::Top.find(@result_sets)
        @result_sets.unshift @top
      end
      # always add the search link?
      # @more                  = ResultSet::More.make(@term)
      # @result_sets.push @more

    end
  end

end
