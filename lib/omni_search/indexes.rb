
module OmniSearch
  ##
  ##
  # Indexes
  # ------------------
  # two Flavours:
  #   PlaintextIndex
  #   TrigramIndex
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
  #      include PlaintextIndexBuilder
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
    @@list = Hash.new()

    def self.list
      @@list[self.to_s] ||= []
    end
    def list
      @@list[self.class.to_s] ||= []
    end

    def initialize
      @contents = {}
    end

    def contents
      @contents = {}
      list.each {|index|
         @contents.merge! index.new.to_hash
      }
      @contents
    end

    def build
      list.each {|index|
        index.new.build
      }
    end

    def self.build
      instance = self.new
      instance.build
    end
  end

  class Indexes::Plaintext < OmniSearch::Indexes
  end

  class Indexes::Trigram < OmniSearch::Indexes
  end

end

