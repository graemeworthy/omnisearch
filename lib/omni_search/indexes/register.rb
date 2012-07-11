# encoding: UTF-8
module OmniSearch
  #
  # Plaintext Index Register -- Module
  # ====================
  #
  # include Indexes::Register
  # indexes :whatever_class
  # if you want to have your class indexed
  #
  # Usage:
  # --------------------
  # 1) Adding an Index:
  #
  # SomeClass
  #   include Indexes::Register
  #   indexes :whatever_class
  #
  # YourClass needs to implement
  #
  #  #collection
  #    - an enumerable collection of objects to be templated
  #
  #  #record_template(item)
  #    - a template, mostly just a hash.
  #
  #  #extended_results_for(item)
  #    - if it's a supermatch (only hit)
  #    - you can provide extra info about the item
  #
  #
  module Indexes::Register
    OMNISEARCH_INDEX = true;
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def indexes(klass_name)
        @index_name = klass_name
        OmniSearch::Indexes.list << self
      end
      def index_name
        raise NotImplementedError, "#{self.class} needs to declare indexes()" unless @index_name
        @index_name.to_s
      end
    end

    def defines_index?
      true
    end

    def all
      collection.collect {|item|
        record_template(item)
      }
    end

    def index_name
      self.class.index_name
    end

    def indexed_class
      index_name.camelize.constantize
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


  end
end
