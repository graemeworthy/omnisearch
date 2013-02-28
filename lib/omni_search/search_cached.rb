# encoding: UTF-8
module OmniSearch

  # does a search via a query cache
  # checks the cache first, to see if there is a result for the term
  # if there is, returns that instead
  # if there is no cached entry, it makes one, and writes it to the cache
  class Search::Cached
    def self.find(term)
      cached_result = OmniSearch::Cache::QueryCache.read(term)
      if cached_result
        cached_result.from_cache = true
        return cached_result
      else
        uncached_result = Search.new(term)
        OmniSearch::Cache::QueryCache.write(term, uncached_result)
        return uncached_result
      end
    end
  end

end

