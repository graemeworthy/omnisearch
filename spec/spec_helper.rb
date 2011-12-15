require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'rails' #fixme

require './lib/omni_search'
include OmniSearch



def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
