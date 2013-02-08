# encoding: UTF-8
module OmniSearch

  # Builds a named index
  # ----------------------------------
  # index_class - like DoctorIndex
  # index_type  - like PlainText
  #
  # it stores DoctorIndex.records,
  # formatted the way thay PlainText needs them
  # in Plaintext::StorageEngine.save
  #
  # Usage:
  # ================================================================
  # Indexes::Builder.new(SomethingIndex, Indexes::Plaintext).save
  #
  class Indexes::Builder

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
    end

    def name
      index_class.index_name
    end

    def collection
      @collection ||= index_class.new.all
    end

    def records
      @records ||= build_index
    end

    def build_index
      index_type.build(collection)
    end

    def storage
      index_type::STORAGE_ENGINE.new(name)
    end

    def save
      storage.save(records)
    end

    def load
      storage.load
    end

  end
end
