module OmniSearch
   # Usage 
   # -------------------------------------
   # OmniSearch::Search.find('term')
   # returns a Results object   
   # if it finds a synonym, that is substituted for term
   # if it finds a 'perfect' match, the intellegent results are also returned
  class Search
    def self.find(term = nil)
      @results = Results.new
    end
  end
end
