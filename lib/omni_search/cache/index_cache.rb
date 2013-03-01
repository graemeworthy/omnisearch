# encoding: UTF-8
module OmniSearch
  # Using the same connection as OmniSearch::Cache
  # We namespace the query into 'index_cache'#
  class Cache::IndexCache < Cache::Base
    def self.namespace_query(query)
        "index_cache:#{query}"
    end
  end
end
