# encoding: UTF-8
require 'singleton'
module OmniSearch
  # we create this as a singleton
  # so that only one connection to the cache exists
  class Cache < ActiveSupport::Cache::MemCacheStore
    include ::Singleton
    def initialize
        server = 'localhost:11211'
        super(server, namespace: 'omnisearch')
    end

  end

  class Cache::Base
    def self.namespace_query(query)
        "#{query}"
    end

    def self.read(query)
        query = self.namespace_query(query)
        Cache.instance.read(query)
    end

    def self.write(query, value)
        query = self.namespace_query(query)
        Cache.instance.write(query, value)
    end

    def self.clear()
        Cache.instance.clear
    end
  end
end
