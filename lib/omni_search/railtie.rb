# encoding: UTF-8
module OmniSearch
  # to be an engine, we must hook into railtie
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__) + '/../../rails/rake.tasks')
    end
  end
end
