# encoding: UTF-8
module OmniSearch
  #
  # Search Strategy
  # ===============
  # basically a configuration class.
  #
  # Usage: Search::Strategy.run('search string')
  #
  # The search strategy is about tuning the results you'd like to see.
  # If you only want high scoring matches, encode that as a strategy.
  # If you want there to be a failover so that every search gets results.
  #  - then encode a 'good results' strategy, with a failover to 'some results'
  #
  class Search::Strategy

    def self.run(term)
      results = ResultSet::Factory.sets(Indexes::Plaintext, Engines::Regex, term, 0)
      return results unless results.empty?
      #failover
      return ResultSet::Factory.sets(Indexes::Plaintext, Engines::StringDistance, term, 0.55)
    end

  end
end