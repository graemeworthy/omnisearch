require './spec/spec_helper'

describe Indexes::Storage::Base do
  let(:the_temp_path){"./test_tmp"}
  let(:the_index_name){'index_name'}
  let(:the_class) {Indexes::Storage::Base}
  let(:the_instance){Indexes::Storage::Base.new(the_index_name)}


  def create_storage
    `mkdir #{the_temp_path}`
  end
  def cleanup_storage
    `rm -rdf #{the_temp_path}`
  end
  before(:all) do
    silently { Indexes::Storage::Base::PATH = the_temp_path }
    create_storage
  end
  after(:all) do
    cleanup_storage
  end

  describe "Constants" do
    it 'BASE_FILENAME is a constant' do
      defined?(Indexes::Storage::Base::BASE_FILENAME).should == "constant"
    end
    it 'PATH is a constant' do
      defined?(Indexes::Storage::Base::PATH).should == "constant"
    end

  end
  describe "Constructors" do
    it 'takes one argument "name"' do
      the_class.new('a name').index_name.should == 'a name'
    end
    it 'fails without the argument' do
      expect { the_class.new }.to raise_error
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
    it '#file_path is PATH + filename' do
      path = Indexes::Storage::Base::PATH
      base = Indexes::Storage::Base::BASE_FILENAME
      name = the_index_name
      the_instance.send(:file_path).should == path+"/"+base+"_"+name
    end
    it '#mkdir ensures the existence of PATH' do
      `rm -rd #{the_temp_path}`
      File.exists?(the_temp_path).should == false
      the_instance.send(:mkdir)
      File.exists?(the_temp_path).should == true
    end
  end
  describe "The Big Picture" do
    it 'saves and retrives data from some file' do

    end

    it 'can be subclassed to use diff paths' do
      class SomeStorage < Indexes::Storage::Base
        BASE_FILENAME = 'heaven'
        PATH          = 'stairway'
      end
      SomeStorage.new('escalator').send(:file_path).should == 'stairway/heaven_escalator'

    end
  end

end
