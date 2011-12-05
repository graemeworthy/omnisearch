# module OmniSearch
module OmniSearch

  class Configuration
    # we need to store indexes somewhere
    attr_accessor :path_to_index_files

    # due to autoloading, we need to explicitly require our
    # search classes from somewhere, this is where we will look
    attr_accessor :path_to_autoload_search_classes_from

    DEFAULTS = {
       :path_to_index_files => '/tmp/omnisearch/',
       :path_to_autoload_search_classes_from => nil
    }

    def initialize(options={})
      DEFAULTS.each do |key,value|
        self.send("#{key}=", options[key] || value)
      end
    end
  end

  # inject the attr_accessor into the class/module, yah.
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
  class ConfigurationError < StandardError
  end
end
