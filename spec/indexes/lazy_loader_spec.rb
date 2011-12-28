require './spec/spec_helper'

describe Indexes::Lazy do
  let(:the_class) {Indexes::Lazy}
  let(:the_instance) {Indexes::Lazy.new()}
  
  describe 'Class Methods' do
    subject {the_class}
    it {should respond_to :load}
  end
  describe 'Instance Methods' do
    subject {the_instance}
    it {should respond_to :load }
    it {should respond_to :indexes_path}
  end

  describe 'the function' do
    before(:all) do
      OmniSearch.configure{|config|
        config.path_to_autoload_search_classes_from = "./spec/examples/index_path"
      }
    end
    after(:all) do
      OmniSearch.configure{|config|
        config.path_to_autoload_search_classes_from = "./spec/examples/search_indexes"
      }
    end

    it 'should not have "SomeClass" defined' do
      defined?(SomeClass).should == nil
    end

    it 'should be defined once Lazy.load has happend!' do
      Indexes::Lazy.load
      defined?(SomeClass).should == 'constant'
    end
  end
end
