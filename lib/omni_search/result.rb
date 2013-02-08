# encoding: UTF-8
module OmniSearch
  # The results of a search.
  # This could have been a struct.
  class Result
    attr_accessor :id
    attr_accessor :value
    attr_accessor :klass
    attr_accessor :raw_data
    attr_accessor :score

    alias_method :label, :value
    def initialize(data={})
      @raw_data   = data
      @score      = data[:score]
      @value      = data[:label]
      @id         = data[:id]
      @klass      = data[:klass]
    end

    def method_missing(id, *args)
      @raw_data[id]
    end

  end
end
