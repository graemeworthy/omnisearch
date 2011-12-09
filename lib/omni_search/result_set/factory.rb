module OmniSearch
  # Usage
  # -----------------------
  # ResultSet::Factory.new(Index, Engine, 'term', cutoff).result_set
  # - or -
  # ResultSet::Factory.set(Index, Engine, 'term', cutoff)
  #
  #
  # - index  = an index object
  #          = Class must respond to new
  #          = instance#contents should be like so
  #            {IndexedClass => [{:value => 'something}]}
  # - engine = a scoring engine object
  #          = instance.new(list, @term).score_list
  #
  # - term   = the search term
  #
  # - cutoff = the lowest score accepted
  #
  # returns an Array of <#ResultSet>s
  #
  class ResultSet::Factory
      def self.sets(*args)
        instance = self.new(*args)
        instance.result_sets
      end

      def initialize(index, engine, term, cutoff = 0)
        @engine = engine
        @index  = index
        @term   = term
        @cutoff = cutoff
        @result_sets = nil
      end

      def index
        @index.new.contents
      end

      def result_sets
        @result_sets ||= build_result_sets
      end

      def build_result_sets
        @result_sets = []
        index.each do |category, items|
          scored_list = score_list(items)
          next if scored_list == []
          @result_sets << ResultSet.new(category, scored_list)
        end
        @result_sets
      end

      def score_list(list)
        @engine.new(list, @term, @cutoff).score_list
      end
  end

end
