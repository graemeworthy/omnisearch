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
require 'omni_search/engines/plaintext/base'
require 'omni_search/engines/plaintext/regex'
require 'omni_search/engines/plaintext/start_distance'
require 'omni_search/synonym'


