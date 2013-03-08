# encoding: UTF-8
require './spec/spec_helper'

describe Indexes::Storage::Base do

  let(:the_class)       { Indexes::Builder }
  let(:the_index_class) { PhysicianIndex }
  let(:the_index_type)  { Indexes::Plaintext }
  let(:the_instance)    do
      Indexes::Builder.new(
        the_index_class,
        the_index_type
    )
  end

  describe 'Constructors' do

    it 'takes two arguments "index_class", and "index_type' do
      the_class.new('an index class', 'an index_type')
    end
  end

  describe 'Instance Methods' do

    describe '#save' do
      it 'calls #save on storage, with records' do
        storage = the_instance.send(:storage)
        records = the_instance.send(:records)
        storage.should_receive(:save).with(records)
        the_instance.save
      end
    end

    describe '#delete' do
      it 'calls #delete on storage' do
         storage = the_instance.send(:storage)
         storage.should_receive(:delete)
         the_instance.delete
      end
    end

    describe '#name' do
      it 'calls #index_name on index_class ' do
        the_index_class.should_receive(:index_name)
        the_instance.send(:name)
      end
    end

    describe '#collection' do
      it 'calls #all on an instance of the index' do
        junk = 'junk'
        instance_mock = mock()
        instance_mock.stub(:all) { junk }
        the_index_class.should_receive(:new).and_return(instance_mock)


        the_instance.send(:collection).should == junk
      end

    end

    describe '#records' do
      it 'calls #build on on the index_type, with the collection' do
        junk = 'junk'
        the_instance.should_receive(:collection).and_return(junk)
        the_index_type.should_receive(:build).with(junk)
        the_instance.send(:records)
      end

    end

    describe '#storage' do
      it 'returns an instance of the index_types storage engine' do
        engine = Indexes::Plaintext.storage_engine
        the_instance.send(:storage).should be_a engine
      end

    end
  end

end
