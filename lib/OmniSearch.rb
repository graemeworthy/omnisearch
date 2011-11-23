require 'yaml'

module OmniSearch
end
$: << File.expand_path( File.dirname(__FILE__))

require 'omnisearch/search'
require 'omnisearch/results'
require 'omnisearch/indexes'
require 'omnisearch/indexes/storage'
require 'omnisearch/indexes/builder'
require 'omnisearch/engines'
require 'omnisearch/engines/plain/base'
require 'omnisearch/engines/plain/regex'
require 'omnisearch/engines/plain/start_distance'



