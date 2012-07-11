require './spec/spec_helper'

describe Indexes do
  let(:dummy_list)  {['cats']}
  let(:the_class) {Indexes}
  let(:the_instance){Indexes.new()}

  describe "Class Methods" do

    it 'class#list exposes instance#list ' do
      the_class.class_variable_set(:@@list, dummy_list)
      the_class.list.should eql ['cats']
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
      @a_index = double()
      @b_index = double()

      the_class.list << @a_index
      the_class.list << @b_index

    end
    it '#build calls :build on everything in @@list' do
      builder_double = double()
      Indexes::Builder.should_receive(:new).at_least(4).times.and_return(builder_double)
      builder_double.should_receive(:save).at_least(4).times

      the_class.build

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
    end

    after(:all) do
      Object.send(:remove_const, :Something)
      Object.send(:remove_const, :SomethingIndex)
      Indexes.list.clear
    end

    it 'Builder adds an instsnce of any including classes to list' do
      Indexes.list.first.should be SomethingIndex
    end

    it 'calls build on all including classes from build' do
      builder_double = double()
      Indexes::Builder.should_receive(:new).
        with(SomethingIndex, Indexes::Plaintext).
        and_return(builder_double)
      Indexes::Builder.should_receive(:new).
        with(SomethingIndex, Indexes::Trigram).
        and_return(builder_double)
      builder_double.should_receive(:save).exactly(2).times
      Indexes.build
    end
  end


end
