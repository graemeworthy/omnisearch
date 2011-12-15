require './spec/spec_helper'

describe ResultSet::Factory do
  before(:all) do
    Indexes.list.clear
    class Something
      def info
        "space"
      end
    end

    class SomethingIndex
      include Indexes::Register
      indexes :something
      def collection
        a_collection = []
        10.times{a_collection << Something.new}
        a_collection
      end
      def record_template(item)
        {:value => item.info}
      end
    end
    Indexes.build
  end

  after(:all) do
    Object.send(:remove_const, :Something)
    Object.send(:remove_const, :SomethingIndex)
    Indexes.list.clear
  end
  let(:some_term)    {"space"}
  let(:the_class)    {ResultSet::Factory}
  let(:the_instance) {ResultSet::Factory.new(Indexes::Plaintext, Engines::Base, some_term)}

  describe "Class Methods" do
    subject {the_class}
    it {should respond_to :sets}

    it "passes through the #sets shortcut to run #result_sets" do
      some_instance = double();
      the_class.should_receive(:new).with('some args').and_return(some_instance)
      some_instance.should_receive(:result_sets)
      the_class.sets('some args')
    end

  end

  describe "Instance Methods" do
    subject {the_instance}
    it {should respond_to :get_records}
    it {should respond_to :get_results}
    it {should respond_to :result_sets}

    it "#get_results(index_class, records) passes a list off to an engine to be scored" do
      records = ['a', 'b', 'c']
      index_class = 'placeholder'
      
      Engines::Base.should_receive(:score).with(records, some_term, 0, index_class)
      the_instance.get_results records, index_class
    end

  end

  describe "ResultSets" do
    subject {the_instance.result_sets}
    it 'should return an array' do
      subject.should be_an Array
    end

    it 'should return an array of ResultSets' do
      subject.first.should be_a ResultSet
    end

    it 'should not return an empty ResultSets' do
      the_instance.stub(:get_results) {[]}
      subject.length.should == 0
    end
  end



end
