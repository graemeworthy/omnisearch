require './spec/spec_helper'

describe Indexes::Register do
  let(:the_class) {Indexes::Register}
  let(:the_instance){Indexes::Register}

  describe "Included" do

    before do
      class SomeIndexClass
        include OmniSearch::Indexes::Register
      end
    end

    after do
      Object.send(:remove_const, :SomeIndexClass)
    end

    it 'adds class methods when included' do
      SomeIndexClass.should respond_to :indexes
    end

    it 'adds the including class to the index list when indexes is called' do
      OmniSearch::Indexes.list.should_receive(:<<).with(SomeIndexClass)
      SomeIndexClass.indexes :something
    end


    describe "Required Implementations" do
      let(:host_class) {SomeIndexClass}
      let(:host_instance) {host_class.new}

      it 'raises unless indexes() is declared' do
        expect { host_instance.index_name }.to raise_error(NotImplementedError)
      end

      it 'raises unless #collection is defined' do
        expect { host_instance.collection }.to raise_error(NotImplementedError)
      end

      it 'raises unless #record_template is defined' do
        expect { host_instance.record_template('') }.to raise_error(NotImplementedError)
      end

      it 'raises unless #extended_results is defined' do
        expect { host_instance.extended_results_for('') }.to raise_error(NotImplementedError)
      end

    end

    describe "Added Methods" do
      let(:host_class) {SomeIndexClass}
      let(:host_instance) {host_class.new}

      it "#defines_index? returns true" do
        host_instance.defines_index?
      end

      # it '#file, holds a storage engine, named after this class' do
      #       host_class.send(:define_method, :index_name) {'test'}
      #       host_instance.file.should be_an Indexes::Storage::Base
      #     end
      #
      #     it '#build_records passes each collection member to record_template' do
      #       host_class.send(:define_method, :collection) {
      #         ['a', 'b']
      #       }
      #
      #       host_instance.should_receive(:record_template).with('a')
      #       host_instance.should_receive(:record_template).with('b')
      #       host_instance.build_records
      #
      #     end
    end

    describe "References to index" do
      before do
        class Peanuts; end
        class SomethingElse
          include Indexes::Register
          indexes :peanuts
        end
      end
      after do
         Object.send(:remove_const, :Peanuts)
         Object.send(:remove_const, :SomethingElse)

      end

      it '#index_name is set by indexes' do

        SomethingElse.new.index_name.should == "peanuts"
      end

      it '#indexed_class returns a camel constant of the index_name ' do
        SomethingElse.new.indexed_class.should == Peanuts
      end
    end

  end



end
