OmniSearch
==================

Fast search for ActiveRecord Models
Relies on memcached

# Todo: Add Redis support

How to use:

include the gem
in your Gemfile add the following

```
gem 'omni_search',     git: 'git@github.com:graemeworthy/omnisearch.git'
```

configure the gem
in /config/intitializers/omnisearch.rb

```
#omnisearch paths
OmniSearch.configure do |config|
  config.path_to_index_files = Rails.root.join 'omnisearch_indices', Rails.env
  config.path_to_autoload_search_classes_from = Rails.root.join 'app', 'search_indexes'
end

#omnisearch weights
OmniSearch::Indexes.list.sort!{|x,y|
  order = [
    LocationIndex,
    ];
  order.index(x) <=> order.index(y)
}
```

create your index models in /app/search_indexes
this example is in /app/search_indexes/location_index.rb

```
class LocationIndex
  include OmniSearch::Indexes::Register
  indexes :location

  def collection
    Location.published
  end

  def record_template(item)
    {:id => item.id, :value => item.name, :label => item.name, :thumbnail => item.thumbnail}
  end

end
```


to search

```
OmniSearch::Search.new query
```
