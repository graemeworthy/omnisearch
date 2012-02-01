# encoding: UTF-8
module OmniSearch

  # Finds the top result in a set of ResultSets
  # Returns a new special resultset, 'TopHit'
  class ResultSet::More

    attr_accessor :top

    def self.make(term)
      result = Result.new({label: term, klass:'Search', score: 1})
      ResultSet.new(ResultSet::More, [result], :search_more)      
    end
  end
end
