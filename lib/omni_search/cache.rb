# encoding: UTF-8
require 'singleton'
module OmniSearch
  # we create this as a singleton
  # so that only one connection to the cache exists
  class Cache < ActiveSupport::Cache::MemCacheStore
    include ::Singleton
    def initialize
        server    = OmniSearch.configuration.memcache_server
        namespace = OmniSearch.configuration.memcache_namespace
        super(server, namespace: namespace)
    end
  end
end
