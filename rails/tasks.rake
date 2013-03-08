# encoding: UTF-8

namespace :omnisearch do

  desc 'builds all indexes'
  task build: :environment do
     OmniSearch::Indexes.build
  end

  desc 'rebuilds all indexes, clears memcache'
  task reindex: :environment do
     OmniSearch::Cache.clear
     OmniSearch::Indexes.destory
     OmniSearch::Indexes.build
  end

  task clear_memcache: :environment do
    puts 'warning: this clears everything in memcache'
     OmniSearch::Cache.clear
  end

  desc 'tests certain matches against the index'
  task test_searches: :environment do
     here = File.expand_path(File.dirname(__FILE__))
     load File.join(here, '../string_tests.rb')
  end

end
