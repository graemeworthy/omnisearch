namespace :omnisearch do
  desc "builds all indexes"
  task :build => :environment do
     OmniSearch::Indexes.build
  end
end
