module OmniSearch

  class Result
    attr_accessor :id
    attr_accessor :value
    attr_accessor :thumbnail
    attr_accessor :klass
    attr_accessor :raw_data
    attr_accessor :score

    alias_method :label, :value
    def initialize(data={})
      @raw_data   = data
      @score      = data[:score]
      @value      = data[:label]
      @id         = data[:id]
      @thumbnail  = data[:thumbnail]
      @klass      = data[:klass]
    end

  end
end