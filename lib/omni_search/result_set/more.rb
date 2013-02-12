# encoding: UTF-8
module OmniSearch

  # Returns a new special resultset, 'More'
  class ResultSet::More

    def self.make(term)
      result = Result.new({label: term, klass: 'Search', score: 1})
      ResultSet.new(ResultSet::More, [result], :search_more)
    end
  end
end
