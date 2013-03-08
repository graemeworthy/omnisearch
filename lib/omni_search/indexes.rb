# encoding: UTF-8
module OmniSearch
  ##
  ##
  # Indexes
  # ------------------
  #
  # Indexes are added to these master classes
  # through 'includes' on anything indexable
  #
  # Usage:
  # -----------------
  # to retrive the contents of an index
  #    PlaintextIndex.new.contents
  # to retrive the contents of an indexed class
  #    PlaintextIndex.new.contents['physicians']
  #
  #
  # to build an index for all indexed models
  #    PlaintextIndex.build
  #
  # to add any class to the index:
  #
  #   class SomeClass
  #      include OmniSearch::Indexes::Register
  #      def index_name
  #         'some_class'
  #      end
  #
  #      def collection
  #        SomeClass.all #<= this should be any enumerable list of properties
  #      end
  #
  #      def record_template(item)
  #        {
  #         :id => item.id,
  #         :value => item.full_name,
  #         :label => "#{item.full_name}  a member of <b> SomeClass </b>"
  #        }
  #      end
  #
  #   end
  ##
  ##
  class Indexes
    @@list = []
    @@lazy_loaded = false


    def self.build
      instance = self.new
      instance.build
    end

    def self.destroy
      instance = self.new
      instance.destroy
    end

    def self.list
      instance = self.new
      instance.list
    end

    def initialize
      lazy_load unless lazy_loaded?
    end

    def list
      @@list ||= []
    end


    def lazy_load
      Indexes::Lazy.load
      @@lazy_loaded = true
    end

    def lazy_loaded?
      @@lazy_loaded
    end

    def each_index(&block)
      index_types   = OmniSearch.configuration.index_types
      index_classes = list

      # product is awesome.
      index_classes.product(index_types) do |i_c, i_t|
        yield(i_c, i_t)
      end
    end

    def build
        each_index do |index_class, index_type|
          Indexes::Builder.new(index_class, index_type).save
        end
    end

    def destroy
        each_index do |index_class, index_type|
          Indexes::Builder.new(index_class, index_type).delete
        end
    end

  end

end
