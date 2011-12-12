module OmniSearch
  #
  # == Engines::Base
  #
  # A base class for all engines
  #
  # Usage
  # -----
  # Engines::Base.new(['peanuts', 'gravy', 'catepillars'], 'search').score_list
  #  - or -
  # Engines::Base.score(['peanuts', 'gravy', 'catepillars'], 'search')
  #
  # Useful Subclasses
  # -----------------
  # This is just the base class
  # Your subclasses will be where all the _real_ work is done.
  #
  # Interfaces
  # --------------
  # Define #score(item)
  # then you'll be happy
  #
  module Engines
    class Base
      # Public: scores an array, using the #score method
      # Returns an array of Results
      def self.score(*args)
        instance = self.new(*args)
        instance.score_list
      end

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
