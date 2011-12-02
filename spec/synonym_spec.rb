require './spec/spec_helper'

describe Synonym do
  let (:the_class) {Synonym}
  let (:the_instance) {Synonym.new({})}

  describe 'Class Methods' do
    subject {the_class}
    it {should respond_to :for}
    it {should respond_to :add}
    it {should respond_to :remove}
    it {should respond_to :correcting_to}    
  end

  describe 'Instance Methods' do
    it {should respond_to :list}
    it {should respond_to :add}
    it {should respond_to :remove}
    
    it {should respond_to :file}
    it {should respond_to :save}
    it {should respond_to :load}
  end

  before(:each) do
    the_class.list.clear
  end

  describe 'adding terms' do

    it 'takes two arguments' do
      expect {the_class.add('some mistake', 'some correction')}.
      to_not raise_error ArgumentError
    end

    it 'doesnt take one arguments' do
      expect {the_class.add('mistake')}.
      to raise_error ArgumentError
    end

    it 'adds a term to the list' do
      the_class.add('a mistake', 'a correction')
      the_class.for('a mistake').should == 'a correction'
    end

    it 'raises AlreadyExists if its a duplicate' do
      the_class.add('a mistake', 'a correction')
      expect {the_class.add('a mistake', 'another correction')}.
      to raise_error Synonym::AlreadyExists
    end

    it 'doesnt raise AlreadyExists if its an exact duplicate' do
      the_class.add('a mistake', 'a correction')
      expect {the_class.add('a mistake', 'a correction')}.
      to_not raise_error Synonym::AlreadyExists
    end

    it 'raises CircularReference if it is one' do
      the_class.add('mistake_a', 'correction')
      expect {the_class.add('mistake_c', 'mistake_a')}.
      to raise_error Synonym::CircularReference
    end

  end

  describe 'remove' do
    it 'removes it from the list' do
      the_class.add('a mistake', 'a correction')
      the_class.remove('a mistake')
      the_class.list.length.should == 0
    end
  end

  describe 'Synonym for' do
    it 'removes it from the list' do
      the_class.add('a mistake', 'a correction')
      the_class.for('a mistake').should == 'a correction'      
    end
  end
  
  describe 'Synonym correcting_to ' do
    it 'removes it from the list' do
      the_class.add('a mistake', 'a correction')
      the_class.add('another mistake', 'a correction')
      the_class.add('unrelated', 'completely')

      the_class.correcting_to('a correction').should == ['a mistake', 'another mistake']
    end
  end


describe 'loading Synoyms from an index' do
    let(:the_temp_path){"./test_tmp"}
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

    it 'declares a storage engines' do
      the_class::STORAGE_ENGINE.should be
    end

    it 'access files through the storage engine' do
      the_instance.file.should be_a the_class::STORAGE_ENGINE
    end

    it '#save saves list to the storage engine' do
      the_class.add('to save', 'the saved')
      the_instance.save
    end


    it ' #load loads the contents of the storage engine' do
      the_class.list.clear
      the_instance.send(:load)
      the_class.list.should == {'to save' => 'the saved'}
    end

    it ' #add saves to the storage engine' do
      the_class.list.clear
      the_instance.send(:load)
      the_class.list.should == {'to save' => 'the saved'}
    end

end

end
