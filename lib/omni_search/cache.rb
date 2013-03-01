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
end
