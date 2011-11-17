module OmniSearch
class Indexes
  module Builder  
  
  ##
  ##
  #
  # Plain Index Builder -- Module
  # ====================
  #
  # include PlainIndexBuilder
  # if you want to have your class
  #
  # Usage:
  # --------------------
  # 1) Adding an Index:
  #
  # SomeClass
  #   include PlainIndexBuilder
  #
  # YourClass needs to implement
  #  #index_name
  #    - just the name
  #
  #  #collection
  #    - an enumerable collection of objects to be templated
  #
  #  #record_template(item)
  #    - a template, mostly just a hash.
  #
  # including PlainIndexBuilder adds your class to PlainIndexes
  #
  # adds the following important methods to your classes
  # 2) Instance Methods
  #   #build
  #    - to save your index to the disk
  #   #records
  #    - to retrieve your records from the disk, translated back from yaml
  #
  ##
  ##

  module Plain
    STORAGE_ENGINE = OmniSearch::Indexes::Storage::Plain
    MASTER_INDEX   = OmniSearch::Indexes::Plain

    def self.included(base)
      class_exec(base){|including|
        #Index.list << including
        MASTER_INDEX.list << including.new
      }
    end

    def index_name
      raise NotImplementedError, "#{self.class} needs to implement index_name"
    end

    def collection
      raise NotImplementedError,"#{self.class} needs to implement collection"
    end

    def record_template(item)
      raise NotImplementedError,"#{self.class} needs to implement record_template"
    end

    def build
      file.save(build_records)
    end

    def load
      file.load
    end

    def to_hash
      {index_name => records}
    end

    def records
      @records ||= file.load
    end

    def build_records
      collection.collect {|item|
        record_template(item)
      }
    end

    def file
      STORAGE_ENGINE.new(index_name)
    end

  end
  
end
end
end

# module OmniSearch
#   class Indexes
#     module Builder
#       module Trigram
#         def self.included(base)
#           class_exec(base){|including|
#             OmniSearch::Indexes::Trigram.list << including.new
#           }
#         end
#       end
#     end
#   end
# end
