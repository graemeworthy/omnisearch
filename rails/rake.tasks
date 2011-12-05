namespace :omnisearch do
  desc "builds all indexes"
  task :build => :environment do
     OmniSearch::Indexes::Plaintext.build
  end
  desc "info about the collections"
  task :info => :environment do
    puts "Indexed Classes"
    puts "===============\n"
      OmniSearch::Indexes.list_all.each do |index_type, indexed_classes| 
        puts "  #{index_type}"
        indexed_classes.each {|klass|
        puts "    #{klass} --> #{klass.new.file.file_path}"

        }
      end
  end
end
