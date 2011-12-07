require './spec/spec_helper'

describe Indexes do
  let(:the_class) {Indexes}
  let(:the_instance){Indexes.new()}

  describe "Class Methods" do
    it '##list exposes @@list ' do
      the_class.list.should == []
    end

    it '##build calls :new and :build' do
      an_instance = double()

      the_class.should_receive(:new).and_return an_instance
      an_instance.should_receive(:build)

      the_class.build
    end
  end

  describe "Instance Methods" do
    before(:each) do
      the_class.list.clear
      @a_builder = double()
      @b_builder = double()
      @a_builder_instance = double()
      @b_builder_instance = double()

      @a_builder.stub(:new){@a_builder_instance}
      @b_builder.stub(:new){@b_builder_instance}

      the_class.list << @a_builder
      the_class.list << @b_builder

    end
    it '#build calls :build on everything in @@list' do

      @a_builder_instance.should_receive(:build)
      @b_builder_instance.should_receive(:build)

      the_class.build

    end

    it '#contents calls :to_hash on everything in @@list' do
       @a_builder_instance.should_receive(:to_hash).and_return({})
       @b_builder_instance.should_receive(:to_hash).and_return({})

      the_instance.contents
    end
    it '#contents merges @@list hashes into itself' do
      a_contents = {:a => 'fun_times'}
      b_contents = {:b => 'groovy_times'}
      @a_builder_instance.should_receive(:to_hash).and_return(a_contents)
      @b_builder_instance.should_receive(:to_hash).and_return(b_contents)
      the_class.class_variable_set(:@@contents, Hash.new) 
      the_instance.contents.should == {:a => 'fun_times', :b => 'groovy_times'}

    end
  end

  describe "Subclasses" do
   it 'keeps its own @@list separate from parent' do
     the_class.list << 'Something'
     Class.new(the_class).list.should == []
   end
  end
  describe "LazyLoading" do
    it 'calls LazyLoad on new if lazy_loaded? is false' do
      the_class.class_variable_set(:@@lazy_loaded, false)
      Indexes::Lazy.should_receive(:load)
      the_class.new
    end
    it "doesn't call LazyLoad on new if lazy_loaded? is true" do
      the_class.class_variable_set(:@@lazy_loaded, true)
      Indexes::Lazy.should_not_receive(:load)
      the_class.new
    end
    it "doesn't call LazyLoad twice" do
      the_class.class_variable_set(:@@lazy_loaded, false)
      Indexes::Lazy.should_receive(:load)
      the_class.new
      the_class.new
    end

  end


  describe "The Big Picture, how it works with Builder for Indexes::Plaintext" do
    before(:all) do
      Indexes::Plaintext.list.clear
      class Includer
        include Indexes::Builder::Plaintext
        def index_name; ""; end
        def collection; [];end
      end
    end
    after(:all) do
      Indexes::Plaintext.list.clear

    end
    it 'Builder adds an instsnce of any including classes to list' do
      Indexes::Plaintext.list.first.should be Includer
    end

    it 'calls build on all including classes from build' do
      Includer.any_instance.should_receive(:build)
      Indexes::Plaintext.build
    end

    it 'calls to_hash on all including classes from contents' do
        Includer.any_instance.should_receive(:to_hash).and_return({})
        the_class.class_variable_set(:@@contents, Hash.new) 
        Indexes::Plaintext.new.contents
    end

  end


end
