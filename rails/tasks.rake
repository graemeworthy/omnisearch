namespace :omnisearch do
  desc "builds all indexes"
  task :build => :environment do
     OmniSearch::Indexes.build
  end

  desc "tests certain matches against the index"
  task :test_searches => :environment do
     here = File.expand_path( File.dirname(__FILE__))
     load File.join(here, "../string_tests.rb")
  end

end
