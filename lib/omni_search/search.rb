module OmniSearch
   # Usage
   # -------------------------------------
   # OmniSearch::Search.find('term')
   # returns a Results object
   # if it finds a synonym, that is substituted for term
   # if it finds a 'perfect' match, the intellegent results are also returned
class Search

    def self.find(term = nil)
      instance = self.new(term)
      instance.find
    end

    def initialize(term = nil)
      @term = term
    end

    def find
      @results =  search_all_indexes
      @results
    end

    def results
    end

    def search_all_indexes
      
      a = Time.now
      results = Results.new OmniSearch::Engines::Regex.new(@term).results
      b = Time.now
      puts "searched regex in: #{b-a} seconds"
      return results if results.top
      a = Time.now
      results = Results.new OmniSearch::Engines::StartDistance.new(@term).results
      b = Time.now
      puts "searched startdist in: #{b-a} seconds"
      results
    end
end
end
