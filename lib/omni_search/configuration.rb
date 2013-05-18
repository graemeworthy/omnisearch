# encoding: UTF-8
module OmniSearch

  ##
  # Sets the location of
  #   file storage
  #   classes which define indexes
  #
  # Usage
  # ---------------------------------
  # OmniSearch.configuration {|config|
  #      config.path_to_index_files =  '/tmp/omnisearch_sparkle/'
  #      config.path_to_autoload_search_classes_from =
  #        File.join(Rails.root, '/app/search_indexes')
  # }
  #
  class Configuration
    # we need to store indexes somewhere
    attr_accessor :path_to_index_files

    # due to autoloading, we need to explicitly require our
    # search classes from somewhere, this is where we will look
    attr_accessor :path_to_autoload_search_classes_from

    # currently there are two types of indicies
    # trigram and plain
    # you may add another index type by adding it to this array
    attr_accessor :index_types

    # memcache server:
    # in the format serveraddress:port
    # the default for memcache is localhost:11211
    attr_accessor :memcache_server

    # memcache namespace:
    # omnisearch not use the global memcache namespace
    attr_accessor :memcache_namespace

    #seach_strategy:
    # the class to call '.run on, with a query'
    attr_accessor :search_strategy

    DEFAULTS = {
      path_to_index_files: '/tmp/omnisearch/',
      path_to_autoload_search_classes_from: nil,
      index_types: [
        Indexes::Plaintext,
        Indexes::Trigram
      ],
      search_strategy: OmniSearch::Search::Strategy,
      memcache_server: 'localhost:11211',
      memcache_namespace: 'omnisearch'
    }

    def initialize(options={})
      DEFAULTS.each do |key, value|
        self.send("#{key}=", options[key] || value)
      end
    end
  end

  # inject the attr_accessor into the class/module, yah.
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
