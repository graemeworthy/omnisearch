# encoding: UTF-8
module OmniSearch

  # Indexes::Base
  #
  class Indexes::Base
    STORAGE_ENGINE = nil

    def self.build(collection)
      instance = self.new
      instance.build_index(collection)
    end

    def self.storage_engine
      self::STORAGE_ENGINE
    end

    def build_index(collection)
      collection
    end

    def storage_engine
      self.class.storage_engine
    end

  end

end
