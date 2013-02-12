# encoding: UTF-8
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
    attr_reader :special_type

    def initialize(klass, results_list, special_type=false)
      @klass = klass
      @results = results_list
      @special_type = special_type
      return if top_hit?
      sort_list
      trim_list
      brand_list
    end

    def label
      label = ''
      if top_hit?
        label = 'Top Hit'
      elsif search_more?
        label = 'Site Search'
      else
        set_name
      end

    end

    def count
      @results.length
    end

    def top_hit?
      @special_type == :top_hit
    end

    def search_more?
      @special_type == :search_more
    end

    def sort_list
      @results.sort! { |a, b| b.score <=> a.score }
    end

    def trim_list
      @results = @results.take(5)
    end

    def brand_list
      @results.each { |item| item.klass = indexed_klass }
    end

    def set_name
      indexed_klass.pluralize.titleize
    end

    protected

    def klass_is_index?
      klass.const_defined?(:OMNISEARCH_INDEX)
    end

    def indexed_klass
      klass_is_index? ? klass.index_name.classify : klass.to_s
    end

  end
end
