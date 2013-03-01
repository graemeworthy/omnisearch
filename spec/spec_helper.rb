# Encoding: UTF-8
require 'simplecov'
SimpleCov.start { add_filter '/spec/' }

require './lib/omni_search'
require './spec/examples/search_indexes/indexes'
include OmniSearch

OmniSearch.configure do |config|
      index_path = './spec/examples/index_path'
      search_classes =  './spec/examples/search_indexes'
      config.path_to_index_files                   = index_path
      config.path_to_autoload_search_classes_from  = search_classes
end




def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
