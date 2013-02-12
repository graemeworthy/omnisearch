require './spec/spec_helper'

describe Indexes::Base do
    let(:the_class){Indexes::Base}

    it 'should have an empty storage engine' do
      the_class.new.storage_engine.should == nil
    end

    it 'should do nothing to the collection on build_index' do
      collection = {ace: 'dude', mace: 'spray'}
      the_class.build(collection).should == collection
    end


end
