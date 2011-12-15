
module OmniSearch
  ##
  ##
  # Indexes
  # ------------------
  #
  # Indexes are added to these master classes through 'includes' on anything indexable
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
  #         :label => "#{item.full_name} <span class='quiet'> a member of SomeClass </span>"
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

    def build
      index_types   = OmniSearch.configuration.index_types
      index_classes = list

      index_classes.each do |index_class|
        index_types.each do |index_type|
          Indexes::Builder.new(index_class, index_type).save
        end
      end
    end

  end

end
