module OmniSearch::Engines
  
  class Base
    def initialize(list, term)
      @list = list
      @term = term    
    end
    def score_list
      @list.each{|item|
        item[:score] = score(item)
      }
    end
    def score(list_item)
      1
    end
  end

  
end