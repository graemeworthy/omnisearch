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

    def initialize(index_type, engine, term, cutoff = 0)
      @engine      = engine
      @index_type  = index_type
      @term        = term
      @cutoff      = cutoff
      @result_sets = nil
    end

    def result_sets
      @result_sets = []
      Indexes.list.each do |index_class|
        records = get_records(index_class)
        results = get_results(records, index_class)
        next unless results.length > 1
        @result_sets << ResultSet.new(index_class, results)
      end
      @result_sets
    end

    def get_records(index_class)
      Indexes::Fetcher.new(index_class, @index_type).records
    end

    def get_results(records, index_class)
      @engine.score(records, @term, @cutoff, index_class)
    end

  end
end
