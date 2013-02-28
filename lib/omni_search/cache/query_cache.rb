# encoding: UTF-8
module OmniSearch
  # Using the same connection as OmniSearch::Cache
  # We namespace the query into 'query_cache'#
  class Cache::QueryCache < Cache::Base
    def self.namespace_query(query)
        "query_cache:#{query}"
    end
  end
end
