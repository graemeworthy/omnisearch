module OmniSearch::Engines
  # there are a variety of engines for searching
  # I'm just going to dump them all in here
  # probably devided by index?
  #
  module Plain
    INDEX = OmniSearch::Indexes::Plain
    INDEXED_FIELD = :value
  end
  class Plain::Base
    attr_accessor :string

    def score(item)
      raise NotImplementedError, "#{self.class} needs to implement score"
    end

    def cutoff
      raise NotImplementedError, "#{self.class} needs to implement cutoff"
    end

    def initialize(string = "")
      @string = string
    end

    def results
      score_index
    end

    protected

    def index
      Plain::INDEX.new.contents
    end

    def score_index
      index.each do |category, items|
        score_items(items)
        sort_items(items)
        trim_below_cutoff(items)
      end
    end

    def score_items(items = [])
      items.each do |item|
         score_item(item)
      end     
    end

    def score_item(item)
      item[:score] = score(item_value(item))
      item
    end
    
    def item_value(item)
      item[Plain::INDEXED_FIELD]
    end


    def trim_below_cutoff(items)
      items.delete_if {|item| item[:score] < cutoff }
    end

    def sort_items(items = [])
      items.sort!{|a, b| b[:score] <=> a[:score] }
      
    end

  end
end