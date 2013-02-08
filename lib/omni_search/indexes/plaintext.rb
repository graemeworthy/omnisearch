# encoding: UTF-8
module OmniSearch
  # Indexes::Plaintext
  class Indexes::Plaintext < Indexes::Base
    STORAGE_ENGINE = Indexes::Storage::Plaintext
    def build_index(collection)
      collection
    end
  end
end