require 'simplecov'
SimpleCov.start
require 'rails'

require './lib/omni_search'
OmniSearch.configure {|config|
  config.path_to_index_files                   = "./spec/examples/index_path"
  config.path_to_autoload_search_classes_from  = "./spec/examples/search_indexes"
}
include OmniSearch



def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
