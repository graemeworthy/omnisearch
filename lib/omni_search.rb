require 'yaml'

module OmniSearch
end
$: << File.expand_path( File.dirname(__FILE__))

require 'omni_search/search'
require 'omni_search/results'
require 'omni_search/results/top'
require 'omni_search/results/extended'
require 'omni_search/indexes'
require 'omni_search/indexes/storage'
require 'omni_search/indexes/builder'
require 'omni_search/engines'
require 'omni_search/engines/plain/base'
require 'omni_search/engines/plain/regex'
require 'omni_search/engines/plain/start_distance'
#require 'omnisearch/engines/plain/string_score'


