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
    attr_accessor :label


    def initialize(klass, results_list, top_hit=false)
      @klass = klass
      @label = 
      @results = results_list
      @top_hit = top_hit
      return if top_hit
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
      @results.each {|item| item.klass = indexed_klass}
    end
    
    protected
    
    def klass_name
      klass.index_name.pluralize.titleize
    end

    def indexed_klass
      klass.index_name.classify.constantize
    end

  end
end