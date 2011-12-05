module OmniSearch

  # given a set of results
  # in the form { 
  #         PizzaIndex => 
  #            [{:score => 12}, 
  #             {:score => 10}]
  #         PantherIndex => 
  #            [{:score => 120}, 
  #             {:score => 11}]
  #           }
  # 
  # Results::Top, when find_top is issued
  # holds just the highest value
  #   {:score => 120}
  #
  # USAGE
  # ========================
  # @top_result = Results::Top.new(results)
  # @top_result.find_top #=> {:score => 120}
  # @top_result.top      #=> {:score => 120}
  #
  # or, the shortcut
  # Results::Top.find(results)
  # {:score => 120}
  # 
class Results::Top
    attr_accessor :top
    def self.find(results)
      instance = self.new(results)
      instance.find_top
      instance.top      
    end
    def initialize(results)
      @results = results
      @top     = nil
      @top_score = 0
    end
    def inspect
      @top
    end
    #they're sorted, we just pick the top one from each hash
    def find_top
        @results.each do |k, v|
           next unless v.first #no empty arrays
           if v.first[:score] > @top_score
             @top = v.first.dup()
             @top_score = v.first[:score]
           end
        end
    end
  end
end
