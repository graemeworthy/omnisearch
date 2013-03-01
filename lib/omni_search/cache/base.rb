# encoding: UTF-8
module OmniSearch
  # The base class for writing cache reader/writer implementations
  # it namespaces the query
  # and provides read, write, and clear methods.
  # it also provides error handling in the case that MemCache Goes down.
  class Cache::Base
    def self.namespace_query(query)
        "#{query}"
    end

    def self.read(query)
        begin
         query = self.namespace_query(query)
         Cache.instance.read(query)
        rescue  MemCache::MemCacheError
          return nil
        end
    end

    def self.write(query, value)
        begin
          query = self.namespace_query(query)
          Cache.instance.write(query, value)
        rescue  MemCache::MemCacheError
          return value
        end
    end

    def self.clear()
        begin
          Cache.instance.clear
        rescue  MemCache::MemCacheError
          return nil
        end
    end
  end
end
