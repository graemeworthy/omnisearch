module OmniSearch
  #
  # A container for the results from a specific index
  # Usage
  # -------------
  # ResultSet.new(SomeIndex, @results)
  #
  class ResultSet
    attr_accessor :results
    attr_accessor :klass


    def initialize(klass, results_list, top_hit=false)
      @klass = klass
      @results = results_list
      @top_hit = top_hit
      sort_list
      trim_list
      brand_list
    end

    def label
      top_hit? ? "Top Hit" : klass_name
    end

    def count
      @results.length
    end

    def top_hit?
      @top_hit
    end

    def sort_list
      @results.sort!{|a, b| b.score <=> a.score }
    end

    def trim_list
      @results = @results.take(5)
    end

    def brand_list
      @results.each {|item| item.klass = @klass}
    end
    
    protected
    
    def klass_name
      klass.to_s.gsub(/Index/,'')
    end

  end
end