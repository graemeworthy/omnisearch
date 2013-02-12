# encoding: UTF-8
module OmniSearch

  #Indexes::Trigram
  class Indexes::Trigram < Indexes::Base
    STORAGE_ENGINE = Indexes::Storage::Trigram

    def build_index(collection)
      values = collection.map{|x| x[:value]}
      Trigram.build_index(values)
    end

  end

end
