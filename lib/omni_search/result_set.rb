
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
      @results = results_list
      @top_hit = top_hit
      return if top_hit
      sort_list
      trim_list
      brand_list
    end

    def label
      top_hit? ? "Top Hit" : set_name
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

    def set_name
      indexed_klass.pluralize.titleize
    end

    protected

    def klass_is_index?
      klass.respond_to? :index_name
    end

    def indexed_klass
      klass_is_index? ? klass.index_name.titleize : klass.to_s
    end

  end
end
