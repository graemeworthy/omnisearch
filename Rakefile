require 'bundler'
Bundler::GemHelper.install_tasks

namespace :tests do
    desc "prepares a fake index in /spec/examples/omnisearch_demo_index"
    task :prepare_fake_index do
      class TestExampleStorage < OmniSearch::Indexes::Storage
        PATH = "./spec/examples"
        BASE_FILENAME = 'omnisearch_demo_index'
      end
      
      
      storage = TestExampleStorage.new
            
      
    end
    
    
end
