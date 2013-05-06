require "./lib/omni_search"
# configure the location of indexes
OmniSearch.configure do |config|
  config.path_to_index_files = "./example/example_indexes"
  config.path_to_autoload_search_classes_from = "./example/example_search_indexes"
end

# build the index
OmniSearch::Indexes.build
# run the search
OmniSearch::Search.new('Par').result_sets.first.results.each do |result|
  puts result.label
end