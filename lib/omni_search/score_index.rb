module OmniSearch
  # Usage
  # -----------------------
  # ScoreIndex.new(Index, Engine, 'term', cutoff).results
  # 
  # - index  = an index object
  #          = Class must respond to new
  #          = instance#contents should be like so
  #            {IndexedClass => [{:value => 'something}]}
  # - engine = a scoring engine object
  #          = instance.new(list, @term).score_list
  # 
  # - term   = the search term
  # 
  # - cutoff = the lowest score accepted
  #
  class ScoreIndex
    def initialize(index, engine, term, cutoff)
      @engine = engine
      @index  = index
      @term   = term
      @cutoff = cutoff
    end

    def index
      contents =  @index.new.contents
      contents
    end

    def results
      score_index
    end

    def score_index
      index.each do |category, items|
        score_list(items)
        sort_list(items)
        trim_list(items)
      end
    end

    def score_list(list)
      @engine.new(list, @term).score_list
    end

    def sort_list(list)
      list.sort!{|a, b| b[:score] <=> a[:score] }
    end
  
    def trim_list(list)
      list.delete_if {|item| item[:score] < @cutoff }
    end
  end
end