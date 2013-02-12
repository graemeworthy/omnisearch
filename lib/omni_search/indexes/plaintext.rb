# encoding: UTF-8
module OmniSearch
  # Indexes::Plaintext
  class Indexes::Plaintext < Indexes::Base
    STORAGE_ENGINE = Indexes::Storage::Plaintext
  end
end