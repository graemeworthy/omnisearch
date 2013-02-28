# encoding: UTF-8
module OmniSearch
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
