require 'simplecov'
SimpleCov.start
require 'rails'

require './lib/omni_search'
OmniSearch.configure {}
include OmniSearch



def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
