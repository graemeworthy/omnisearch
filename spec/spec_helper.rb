require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'rails' #fixme

require './lib/omni_search'
include OmniSearch

OmniSearch.configure {|config|
      index_path = "./spec/examples/index_path"
      search_classes =  "./spec/examples/search_indexes"
      config.path_to_index_files                   = index_path
      config.path_to_autoload_search_classes_from  = search_classes
}




def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
