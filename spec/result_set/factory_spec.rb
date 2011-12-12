require './spec/spec_helper'

describe ResultSet::Factory do
  let(:some_index)   {
    index_double = double();
    index_double.stub(:new) {index_double}
    index_double.stub(:contents) {
      {
        "index_class" =>
        [{:name => 'all of my example things'}]
      }
    }
    index_double
  }

  let(:some_engine)   {double().as_null_object}
  let(:some_term)    {"term"}
  let(:the_class)    {ResultSet::Factory}
  let(:the_instance) {ResultSet::Factory.new(some_index, some_engine, some_term)}

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
    it {should respond_to :index}
    it {should respond_to :index_contents}
    it {should respond_to :result_sets}
    it {should respond_to :score_list}

    it "#index instantiates @index" do
      some_index.should_receive(:new)
      the_instance.index
    end

    it "#index_contents calls contents on index" do
      the_instance.should_receive(:index).and_return(some_index)
      some_index.should_receive(:contents)
      the_instance.index_contents
    end

    it "#score_list(list) passes a list off to an engine to be scored" do
      list = ['a', 'b', 'c']
      some_engine_instance = double()
      some_engine.should_receive(:score).with(list, 'term', 0)
      the_instance.score_list list
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
      the_instance.stub(:score_list) {[]}
      subject.length.should == 0
    end
  end



end
