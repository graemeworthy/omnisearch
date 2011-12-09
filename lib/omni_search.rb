require 'yaml'

module OmniSearch
end
$: << File.expand_path( File.dirname(__FILE__))

require 'omni_search/railtie'
require 'omni_search/configuration'
require 'omni_search/search'

require 'omni_search/result'
require 'omni_search/result_set'
require 'omni_search/result_set/factory'
require 'omni_search/result_set/top'
require 'omni_search/result_set/extended'

require 'omni_search/indexes'
require 'omni_search/indexes/storage'
require 'omni_search/indexes/builder'
require 'omni_search/indexes/lazy_loader'

require 'omni_search/engines'
require 'omni_search/engines/base'
require 'omni_search/engines/regex'
require 'omni_search/engines/start_distance'

require 'omni_search/auto_correct'
require 'omni_search/correction'



