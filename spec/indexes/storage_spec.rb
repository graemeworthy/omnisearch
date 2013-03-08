require './spec/spec_helper'

describe Indexes::Storage::Base do
  let(:the_temp_path){"./test_tmp"}
  let(:the_index_name){'index_name'}
  let(:the_temp_file){"#{the_temp_path}/omnisearch_index_#{the_index_name}"}

  let(:the_class) {Indexes::Storage::Base}
  let(:the_instance){Indexes::Storage::Base.new(the_index_name)}
  let(:data_to_save) {{:a => 'pie', :for => 'me please'}}

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
      index_path     = './spec/examples/index_path'
      search_classes =  './spec/examples/search_indexes'
      config.path_to_index_files                   = index_path
      config.path_to_autoload_search_classes_from  = search_classes
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


    describe '#exists?' do
      it 'should return true if the file exists' do
        the_instance.save(data_to_save)
        the_instance.send(:exists?).should == true
      end

      it 'should return false if it does not exits' do
        cleanup_storage
        the_instance.send(:exists?).should == false
      end
    end

    describe  '#save' do
      before(:each) do
        cleanup_storage
      end

      after(:each) do
        cleanup_storage
      end

      it 'serializes its argument to file_path, as YAML' do
        the_instance.should_receive(:serialize).with(data_to_save)
        the_instance.save(data_to_save)
      end

      it 'creates the file' do
        the_instance.save(data_to_save)
        stored_at = the_instance.send(:file_path)
        File.exists?(stored_at).should == true
      end

      it 'fills the file with serialized data' do
        the_instance.save(data_to_save)
        expected = the_instance.send(:serialize, data_to_save)
        actual = File.read(the_instance.send(:file_path))
        actual.should == expected
      end

      it 'ensures there is a path to write to' do
        #original state check
        root_path = the_instance.send(:root_path)
        File.exists?(root_path).should == false
        the_instance.save(data_to_save)
        File.exists?(root_path).should == true
      end
    end

    describe '#load' do
      it  'retrives unserialized data from file_path' do
        the_instance.save(data_to_save)
        the_instance.load.should == data_to_save
      end

      it 'raises unless that file exists' do
        cleanup_storage
        expect { the_instance.load }.to raise_error MissingIndexFile
      end
    end

    describe '#delete' do
      before(:each){
        the_instance.save(data_to_save)
      }
      it 'removes the index file' do
        the_instance.send(:exists?).should == true # check that it's there
        the_instance.delete
        the_instance.send(:exists?).should == false
      end
    end

    describe '#serialize' do
      it 'converts the records with yaml' do
        YAML.should_receive(:dump)
        the_instance.send(:serialize, data_to_save)
      end
      it 'is called by save' do
        the_instance.should_receive(:serialize)
        the_instance.send(:serialize, data_to_save)
      end
    end

    describe '#deserialize' do
      before do
        the_instance.save(data_to_save)
      end
      it 'converts the records with yaml' do
        YAML.should_receive(:load)
        the_instance.send(:deserialize, 'whatever')
      end
      it 'is called by load' do
        the_instance.should_receive(:deserialize)
        the_instance.load
      end
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
      $VERBOSE = nil
      class SomeStorage < Indexes::Storage::Base
        BASE_FILENAME = 'heaven'
        def root_path
          "stairway"
        end
      end
      $VERBOSE = 1
    end

    after do
      `rm -rdf stairway`
    end

    it 'saves and retrives data from some file' do
      storage = SomeStorage.new('escalator')
      storage.save(data_to_save)
      storage.load.should == data_to_save
    end

    it 'can be subclassed to use diff paths' do
      storage = SomeStorage.new('escalator')
      path = storage.send(:file_path)
      path.should == 'stairway/heaven_escalator'

    end
  end

end
