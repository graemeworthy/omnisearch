# encoding: UTF-8

namespace :omnisearch do

  desc 'builds all indexes'
  task build: :environment do
     OmniSearch::Indexes.build
  end

  desc 'rebuilds all indexes, clears memcache'
  task reindex: :environment do
     OmniSearch::Indexes.destroy
     OmniSearch::Indexes.build
     OmniSearch::Cache.clear
  end

  desc 'clears memcache'
  task clear_memcache: :environment do
    puts 'warning: this clears everything in memcache'
     OmniSearch::Cache.clear
  end

  desc 'searches every two letter combination of a-z (aa, ab..)'
  task warm_cache: :environment do
    first_letter = ('a'..'z').to_a
    second_letter = ('a'..'z').to_a
    first_letter.product(second_letter) do |first, second|
      OmniSearch::Search::Cached.find "#{first}#{second}"
    end

  end

  desc 'tests certain matches against the index'
  task test_searches: :environment do
     here = File.expand_path(File.dirname(__FILE__))
     load File.join(here, '../string_tests.rb')
  end

end
