# encoding: UTF-8
module OmniSearch

  # Builds a named index
  # ----------------------------------
  # index_class - like DoctorIndex
  # index_type  - like PlainText
  #
  # it stores DoctorIndex.records,
  # formatted the way thay PlainText needs them
  #
  #
  # Usage:
  # ================================================================
  # instance = Indexes::Builder.new(SomethingIndex, Indexes::Plaintext)
  # instance.save
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

    # save the constructed records to the storage engine
    def save
      storage.save(records)
    end

    # deletes the stored records
    def delete
      storage.delete
    end

    private

    def name
      index_class.index_name
    end

    def index
      @index ||= index_class.new
    end

    def collection
      index.all
    end

    # formats the collection using the index_type's build rules
    def records
      index_type.build(collection)
    end

    # creates an instance of the storage engine
    def storage
      @storage ||= index_type.storage_engine.new(name)
    end

  end
end
