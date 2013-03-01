# encoding: UTF-8
module OmniSearch

  # Fetches a named index
  # ----------------------------------
  # index_class - like DoctorIndex
  # index_type  - like PlainText
  #
  #
  # Usage:
  # ================================================================
  # instance = Indexes::Fetcher.new(SomethingIndex, Indexes::Plaintext)
  # instance.records
  class Indexes::Fetcher

    # index_class holds an one of the user configurable classes.
    #  see Indexes::Register, for how an index_class is specified
    attr_accessor :index_class

    # index_type holds the index generator
    # while a plaintext index is straightforward, a trigram index
    # requires the index class to do some work
    attr_accessor :index_type

    def initialize(index_class, index_type)
      @index_class = index_class
      @index_type  = index_type
      @records = nil
    end

    def name
      index_class.index_name
    end

    # Public: a memoized value of read_through cache
    def records
      @records ||= read_through_cache
    end

    # cache must be index type, and index_class
    # otherwise plaintext will override trigram or whatever
    def cache_name
      "#{index_type}_#{index_class}"
    end

    # if it's already in the cache, return it
    # if it's not already in the cache, add it
    # in any case, return it
    def read_through_cache
       read_cache || load_to_cache
    end

    # saves a set of records to cache, returns what you saved
    # we rely on it returning because read_through likes
    # it.
    def save_to_cache(records)
      cache.write(cache_name, records)
      return records
    end

    # reads the index cache, at cache_name
    def read_cache
      cache.read(cache_name)
    end

    def cache
      OmniSearch::Cache::IndexCache
    end

    # loads from storage, saves to cache
    def load_to_cache
      save_to_cache(load)
    end

    # an instance of the index_type's storage engine
    def storage
      # fixme, ask index_type to instantiate this for us.
      index_type::STORAGE_ENGINE.new(name)
    end

    # loads from storage
    def load
      storage.load
    end


  end
end
