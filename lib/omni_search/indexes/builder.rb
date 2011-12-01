module OmniSearch
class Indexes
  module Builder

  ##
  ##
  #
  # Plaintext Index Builder -- Module
  # ====================
  #
  # include PlaintextIndexBuilder
  # if you want to have your class
  #
  # Usage:
  # --------------------
  # 1) Adding an Index:
  #
  # SomeClass
  #   include PlaintextIndexBuilder
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
  # including PlaintextIndexBuilder adds your class to PlaintextIndexes
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
  module Base

    # the following is a fancy bit of metaprogramming..
    # i'm sorry, really it's too clever, but I had something I needed to do
    # when Base is included in another module..
    #   we add all ClassMethods as class methods (hence no self.xxx)
    # then when Plaintext, (or Trigram) are included we're already safe, and this doesn't happen again..
    #
    def self.included(base)
        base.extend ClassMethods
    end

    module ClassMethods
      def included(base)
        class_exec(base){|including|
          self::MASTER_INDEX.list << including
          self::MASTER_INDEX.list.uniq!          
        }
      end
    end

    def index_name
      raise NotImplementedError, "#{self.class} needs to implement index_name"
    end

    def collection
      raise NotImplementedError, "#{self.class} needs to implement collection"
    end

    def record_template(item)
      raise NotImplementedError, "#{self.class} needs to implement record_template"
    end

    def extended_results_for(item)
      raise NotImplementedError, "#{self.class} needs to implement extended_results_for"
    end

    def build
      file.save(build_records)
    end

    def load
      file.load
    end

    def to_hash
      {self.class => records}
    end

    def records
      @records ||= load
      @records.dup

    end

    def build_records
      collection.collect {|item|
        record_template(item)
      }
    end

    def file
      self.class::STORAGE_ENGINE.new(index_name)
    end

  end

  module Plaintext
    include Base
    STORAGE_ENGINE = OmniSearch::Indexes::Storage::Plaintext
    MASTER_INDEX   = OmniSearch::Indexes::Plaintext
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
