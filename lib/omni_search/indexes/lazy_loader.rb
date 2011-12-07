module OmniSearch
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