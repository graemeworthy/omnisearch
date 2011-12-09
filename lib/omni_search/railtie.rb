module OmniSearch
  class Railtie < Rails::Railtie
    rake_tasks do
       load File.join( File.dirname(__FILE__) + "/../../rails/rake.tasks")
     end
  end
end