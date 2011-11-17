require './spec/spec_helper'

describe Indexes::Storage::Base do
  let(:the_class) {Indexes::Storage::Base}
  let(:the_instance){Indexes::Storage::Base.new()}

  describe "Constants" do
    it 'BASE_FILENAME is a constant'
    it 'PATH is a constant'
  end
  describe "Constructors" do
    it 'takes one argument "name"'
  end
  describe "Instance Methods" do
    it '#save serializes its argument to file_path, as YAML'
    it '#load retrives unserialized data from file_path'

  end
  describe 'Protected Methods' do
    it '#filename is BASE_FILENAME + name'
    it '#file_path is PATH + filename'
    it '#mkdir ensures the existence of PATH'
  end

  describe "The Big Picture" do
    it 'saves and retrives data from some file'
    it 'can be subclassed to use diff paths'
  end

  describe "Subclasses" do
   it 'can have diff PATHs and BASE_FILENAMEs'
  end

end
