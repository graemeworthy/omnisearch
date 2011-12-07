
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
    @@list = Hash.new
    @@contents = Hash.new
    @@lazy_loaded = false


    def self.build
      instance = self.new
      instance.build
    end

    def self.list
      instance = self.new
      instance.list
    end

    def self.list_all
      instance = self.new
      instance.list_all
    end


    def list
      @@list[self.class.to_s] ||= []
    end

    def list_all
      @@list
    end

    def initialize
      lazy_load unless lazy_loaded?

    end

    def lazy_load
      Indexes::Lazy.load
      @@lazy_loaded = true
    end

    def lazy_loaded?
      @@lazy_loaded
    end

    #either fetches and builds the index.. or returns a copy
    def contents
       these_contents = @@contents[self.class.to_s]
       return deep_copy(these_contents) if these_contents
       @@contents[self.class.to_s] = Hash.new
       list.each {|index|
          @@contents[self.class.to_s].merge! index.new.to_hash
       }
       these_contents = @@contents[self.class.to_s]
       return deep_copy(these_contents)
    end

    # clone and dup produce shallow copies
    # the operations of the engines are destructive( they score, they trim)
    # and shallow copies get scored and trimmed, rather frustratingly
    def deep_copy(hash)
      new_hash = {}
      old_hash = hash
      old_hash.each {|k, v|
        new_hash[k] = v.dup
        }
      new_hash
    end
    def build
      list.each {|index|
        index.new.build
      }
    end

  end

  class Indexes::Plaintext < OmniSearch::Indexes
  end

  # class Indexes::Trigram < OmniSearch::Indexes
  # end


end

