# encoding: UTF-8
module OmniSearch

  # The base class for writing cache reader/writer implementations
  # it namespaces the query
  # and provides read, write, and clear methods.
  # it also provides error handling in the case that MemCache Goes down.
  class Cache::Base
    # Public: takes a key(string)
    # and modifies it to namespace it
    # returns a string
    def self.namespace_key(key)
        "#{key}"
    end

    # wrapper for Cache#read
    #
    def self.read(key)
        begin
         ns_key = self.namespace_key(key)
         Cache.instance.read(ns_key)
        rescue  Dalli::DalliError
          return nil
        end
    end

    # wrapper for Cache#write
    # returns the passed value
    # caches missing memcache errors
    def self.write(key, value)
        begin
          ns_key = self.namespace_key(key)
          Cache.instance.write(ns_key, value)
        rescue  Dalli::DalliError
          return value
        end
        return value
    end

    # wrapper for Cache#refresh
    def self.refresh
        begin
          Cache.refresh
        rescue  Dalli::DalliError
          return nil
        end
    end
  end
end
