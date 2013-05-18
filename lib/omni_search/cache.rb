# encoding: UTF-8
module OmniSearch

  # we create this as a singleton
  # so that only one connection to the cache exists
  #
  class Cache < ActiveSupport::Cache::MemCacheStore
    include ::Singleton
    attr_accessor :timestamp
    def initialize
        server    = OmniSearch.configuration.memcache_server
        @namespace = OmniSearch.configuration.memcache_namespace
        @timestamp = new_timestamp
        super(server, namespace: Proc.new{stamped_namespace})
    end

    def self.refresh
        self.instance.refresh
    end

    def refresh
      @timestamp = new_timestamp
    end

    def new_timestamp
      Time.now.to_i
    end

    def stamped_namespace
      "#{@namespace}_#{@timestamp}"
    end

  end
end
