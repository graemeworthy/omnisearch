require 'simplecov'
SimpleCov.start


require './lib/omnisearch'
include OmniSearch


def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end
