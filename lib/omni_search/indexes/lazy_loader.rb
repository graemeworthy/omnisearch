# encoding: UTF-8
module OmniSearch
  # Lazy Loader
  # --------------
  # Rails doesn't load all classes
  # since our indexes are built by 'include'
  # we need the indexed classes to be loaded
  # this does that

  # Usage
  # ---------------------
  # OmniSearch.configure {|config|
  #  config.path_to_autoload_search_classes_from = /Some/Path
  # }
  # Indexes::Lazy.load
  #   requires all *.rb files in that path
  #
  class Indexes::Lazy
    def initialize
      @config = OmniSearch.configuration
    end

    def self.load
      instance = self.new
      instance.load
    end

    def load
      if indexes_path
        Dir[indexes_path + '/*.rb'].each {|file| require file }
      end
    end

    def indexes_path
      @config.path_to_autoload_search_classes_from.to_s
    end
  end
end
