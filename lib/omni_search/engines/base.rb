
module OmniSearch
  module Engines
    class Base
      def initialize(list, term, cutoff = 0)
        @list = list
        @term = term
        @results = []
        @cutoff = cutoff
      end

      def score_list
        @list.each{|item|
          item ||= {}
          item_score = score(item)
          scored_item = item.merge(:score => item_score)
          @results << Result.new(scored_item) if item_score > @cutoff
        }
        @results
      end

      def score(item)
        1
      end
    end
  end
end