module OmniSearch

  class Result
    attr_accessor :id
    attr_accessor :klass
    attr_accessor :value
    attr_accessor :img
    attr_accessor :raw_data
    attr_accessor :score

    def initialize(raw_data, score)
     raw = raw_data
     @score = score
     @value = raw[:label]
     @id    = raw[:id]
     @img   = raw[:img]

    end
    def raw=(raw)
      p "raw = #{raw}"
      @raw_data = raw
    end
    def raw
      @raw_data
    end

  end
end