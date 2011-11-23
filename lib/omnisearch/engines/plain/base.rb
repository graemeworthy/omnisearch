module OmniSearch::Engines
  # there are a variety of engines for searching
  # I'm just going to dump them all in here
  # probably devided by index?
  #
  module Plain
    INDEX = OmniSearch::Indexes::Plain
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
      @top_score = 0
      @top_hit
    end

    def results
      result = score_index
      if @top_score > 0
        result[:top_hit] = [@top_hit]
      end
      result
    end

    protected

    def index
      @index ||= Plain::INDEX.new.contents
    end

    def score_index
      index.each do |category, items|
        score_items(items, :value)
        sort_items(items)
      end
    end

    def score_items(items = [], field = 'value')
      items.each do |item|
         score_item(item, field)
         top_test(item)
      end
      trim_below_cutoff(items)
    end

    def score_item(item, field)
      item_score = score(item[field])
      item[:score] = item_score
      item
    end

    def top_test(item)
      return if item[:score] < cutoff
      if item[:score] >= @top_score
        @top_score = item[:score]
        @top_hit = item
      end
    end

    def trim_below_cutoff(items)
      items.delete_if {|item| item[:score] < cutoff }
    end

    def sort_items(items = [])
      items.sort!{|a, b| b[:score] <=> a[:score] }
    end

  end
end