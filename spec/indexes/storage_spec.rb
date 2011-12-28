require './spec/spec_helper'

describe Indexes::Storage::Base do
  let(:the_temp_path){"./test_tmp"}
  let(:the_index_name){'index_name'}
  let(:the_temp_file){"#{the_temp_path}/omnisearch_index_#{the_index_name}"}

  let(:the_class) {Indexes::Storage::Base}
  let(:the_instance){Indexes::Storage::Base.new(the_index_name)}

  def create_storage
    `mkdir #{the_temp_path}`
  end
  def cleanup_storage
    `rm -rdf #{the_temp_path}`
  end
  before(:all) do
    OmniSearch.configure {|config|
      config.path_to_index_files = the_temp_path
    }
    create_storage
  end

  after(:all) do
    cleanup_storage
    OmniSearch.configure {|config|
      config.path_to_index_files                   = "./spec/examples/index_path"
      config.path_to_autoload_search_classes_from  = "./spec/examples/search_indexes"
    }
  end

  describe "Constants" do

    it 'BASE_FILENAME is a constant' do
      defined?(Indexes::Storage::Base::BASE_FILENAME).should == "constant"
    end

  end

  describe "Constructors" do

    it 'takes one argument "name"' do
      the_class.new('a name').index_name.should == 'a name'
    end

  end
  describe "Instance Methods" do
    let(:data_to_save) {{:a => 'pie', :for => 'me please'}}

    it '#save serializes its argument to file_path, as YAML' do
      the_instance.save(data_to_save)
      stored_at = the_instance.send(:file_path)
      File.exists?(stored_at).should == true
    end

    it '#load retrives unserialized data from file_path' do
      the_instance.load.should == data_to_save
    end

    it '#load raises unless that file exists' do
      cleanup_storage
      expect { the_instance.load }.to raise_error
    end

  end
  describe 'Protected Methods' do
    it '#filename is BASE_FILENAME + name' do
      base = Indexes::Storage::Base::BASE_FILENAME
      name = the_index_name
      the_instance.send(:filename).should == base+"_"+name
    end

    it '#file_path is root_path + filename' do
      path = the_instance.send(:root_path)
      base = Indexes::Storage::Base::BASE_FILENAME
      name = the_index_name
      the_instance.send(:file_path).should == path+"/"+base+"_"+name
    end

    it '#mkdir ensures the existence of root_path' do
      `rm -rd #{the_temp_path}`
      File.exists?(the_temp_path).should be false
      the_instance.send(:mkdir)
      File.exists?(the_temp_path).should be true
    end

    it '#touch ensures the existence of the file' do
      `rm -rd #{the_temp_path}`
      File.exists?(the_temp_file).should be false
      the_instance.send(:touch)
      File.exists?(the_temp_file).should be true
    end

  end
  describe "The Big Picture" do
    before do
      class SomeStorage < Indexes::Storage::Base
        BASE_FILENAME = 'heaven'
        def root_path
          "stairway"
        end
      end
    end
    after do
      `rm -rdf stairway`
    end

    it 'saves and retrives data from some file' do

    end

    it 'can be subclassed to use diff paths' do

      SomeStorage.new('escalator').send(:file_path).should == 'stairway/heaven_escalator'

    end
  end

end
