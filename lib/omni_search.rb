# encoding: UTF-8
require 'yaml'
require 'memcache'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext/string/inflections'
require 'active_support/cache/mem_cache_store'

module OmniSearch
end

here = File.expand_path(File.dirname(__FILE__))
$: << here

#require 'omni_search/railtie'
require 'omni_search/errors'
require 'omni_search/search'
require 'omni_search/search_cached'
require 'omni_search/search_strategy'

require 'omni_search/result'
require 'omni_search/result_set'
require 'omni_search/result_set/factory'
require 'omni_search/result_set/top'
require 'omni_search/result_set/extended'
require 'omni_search/result_set/more'

require 'omni_search/indexes'
require 'omni_search/indexes/register'
require 'omni_search/indexes/storage'
require 'omni_search/indexes/builder'
require 'omni_search/indexes/fetcher'
require 'omni_search/indexes/lazy_loader'
require 'omni_search/indexes/base'
require 'omni_search/indexes/trigram'
require 'omni_search/indexes/plaintext'

require 'omni_search/engines'
require 'omni_search/engines/base'
require 'omni_search/engines/regex'
require 'omni_search/engines/start_distance'
require 'omni_search/engines/string_distance'
require 'omni_search/engines/triscore'

require 'omni_search/cache'
require 'omni_search/cache/base'
require 'omni_search/cache/query_cache'
require 'omni_search/cache/index_cache'

require 'omni_search/auto_correct'
require 'omni_search/correction'

require 'omni_search/configuration'
require 'tools/trigram'
require 'tools/string_distance'
require 'tools/word_distance'

#LOAD RAKE TASKS, if you happen to be rake
load File.join(here, '../rails/tasks.rake') if defined?(Rake)
