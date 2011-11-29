require './spec/spec_helper'

describe Indexes::Builder do
  let(:the_module) {Indexes::Builder}
  it 'exists to hold things' do
    the_module.should be
  end

end

describe Indexes::Builder::Plain do
  let(:the_class) {Indexes::Builder::Plain}
  let(:the_instance){Indexes::Builder::Plain.new}

  describe "Constants" do
    it 'STORAGE_ENGINE should be a storage engine' do
      the_class::STORAGE_ENGINE.superclass.should == Indexes::Storage::Base
    end
    it 'MASTER_INDEX should be an Index, by which i mean a child_class of Index' do
      #the 'master index' is the one that holds 'the list'
      the_class::MASTER_INDEX.superclass.should == Indexes
    end
  end

  describe "Including" do
    before(:all) do
      Indexes::Plain.list.clear
      class Something
        include Indexes::Builder::Plain
      end
    end

    after(:all) do
      Indexes::Plain.list.clear
    end

    it 'adds itself to some Index#list when included' do
      the_class::MASTER_INDEX.list.first.should be_a Something
    end

    describe "Required Implementations" do
      let(:host_class) {Something}
      let(:host_instance) {host_class.new}

      it 'raises unless #index_name is defined' do
        expect { host_instance.index_name }.to raise_error
      end

      it 'raises unless #collection is defined' do
        expect { host_instance.collection }.to raise_error
      end

      it 'raises unless #record_template is defined' do
        expect { host_instance.record_template('') }.to raise_error
      end

      it 'raises unless #extended_results is defined' do
        expect { host_instance.extended_results('') }.to raise_error
      end

    end


    describe "Added Methods" do
      let(:host_class) {Something}
      let(:host_instance) {host_class.new}


      it '#file, holds a storage engine, named after this class' do
        host_class.send(:define_method, :index_name) {'test'}
        host_instance.file.should be_an Indexes::Storage::Base
      end

      it '#build_records passes each collection member to record_template' do
        host_class.send(:define_method, :collection) {
          ['a', 'b']
        }

        host_instance.should_receive(:record_template).with('a')
        host_instance.should_receive(:record_template).with('b')
        host_instance.build_records

      end
      it '#build saves all records to storage' do
        fake_records = ['something', 'somethingelse']
        fake_storage = double()

        host_instance.should_receive(:build_records).and_return(fake_records)
        host_instance.should_receive(:file).and_return(fake_storage)
        fake_storage.should_receive(:save).with(fake_records)

        host_instance.build
      end

      it '#load retrieves a set of records from storage' do
        fake_storage = double()

        host_instance.should_receive(:file).and_return(fake_storage)
        fake_storage.should_receive(:load)

        host_instance.load
      end

      it '#records memoizes #load' do
        host_instance.stub(:load){"original"}
        host_instance.records.should == 'original'
        host_instance.stub(:load){"changed"}
        host_instance.records.should == 'original'
      end

      it '#to_hash creates a simple hash for merging upstream' do
        host_instance.stub(:records) {['canadians']}

        host_instance.to_hash.should == {Something => ['canadians']}
      end

    end

  end
end


