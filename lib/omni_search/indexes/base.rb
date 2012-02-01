# encoding: UTF-8
module OmniSearch
  # Indexes::Base

  class Indexes::Base
    @@contents = Hash.new
    STORAGE_ENGINE = nil

    def self.build(collection)
      instance = self.new
      instance.build_index(collection)
    end

    #cattr_accessor :contents

    def build_index(collection)
      collection
    end

    def storage_engine
      self.class::STORAGE_ENGINE
    end

  end

  # Indexes::Plaintext
  class Indexes::Plaintext < Indexes::Base
    STORAGE_ENGINE = Indexes::Storage::Plaintext
    def build_index(collection)
      collection
    end
  end

  #Indexes::Trigram
  class Indexes::Trigram < Indexes::Base
    STORAGE_ENGINE = Indexes::Storage::Trigram
    def build_index(collection)
      values = collection.map{|x| x[:value]}
      Trigram.build_index(values)
    end
  end

end
