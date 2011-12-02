module OmniSearch
   # Usage
   # -------------------------------------
   # OmniSearch::Search.find('term')
   # returns a Results object
   # if it finds a synonym, that is substituted for term
   # if it finds a 'perfect' match, the intellegent results are also returned
class Search

    def self.find(query = nil)
      instance = self.new(query)
      instance.find
    end

    def initialize(query = nil)
      @query = query
      @term =  query
      @synonym = false
      
      check_synonyms
    end
 
    def find
      @results =  search_all_indexes
      @results.searching_as = {:mistake => @query, :correction => @term} if @synonym
      @results
    end
  
    def results
      @results
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
    
    def check_synonyms
      @synonym = Synonym.for(@term)
      @term = @synonym if @synonym
    end
end
end
