module OmniSearch

  # Finds the top result in a set of ResultSets
  # Returns a new special resultset, 'TopHit'
  class ResultSet::Top

    attr_accessor :top

    def self.find(result_sets)
      instance = self.new(result_sets)
      instance.find_top
      instance.top
      ResultSet.new(ResultSet::Top, [instance.top], true)
    end

    def initialize(  result_sets)
      @result_sets = result_sets
      @top     = nil
      @top_score = 0
    end

    #they're sorted, we just pick the top one from each hash
    def find_top
      @result_sets.each do |set|
        check set.results.first
      end
    end

    def check(item)
      return unless item.score > @top_score
      @top_score = item.score
      @top       = item
    end

  end
end
