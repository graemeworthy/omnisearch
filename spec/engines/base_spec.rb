require './spec/spec_helper'

describe "Engines::Base" do

  let(:fake_term) {'peanuts'}
  let(:fake_list) {
    [
      {:id => 1, :value => 'puppies'},
      {:id => 2, :value => 'kittens'},
      {:id => 3, :value => 'apples'},
      {:id => 4, :value => 'oranges'},
    ]
  }
  let(:the_class)    {Engines::Base}
  let(:the_instance) {Engines::Base.new(fake_list, fake_term)}

  describe 'Constructor' do
    it 'takes two or three arguments' do
      the_class.new(fake_list, fake_term, 0).should be
      the_class.new(fake_list, fake_term).should be
    end
  end

  describe 'Class Methods' do
    subject {the_class}
    it {should respond_to :score}
    it 'score(x,y,z) is just a proxy for new(x, y, z).score_list' do
      args = ['x', 'y', 'z']
      instance = double()
      the_class.should_receive(:new).with(args).and_return(instance)
      instance.should_receive(:score_list)
      the_class.score(args)
    end
  end

  describe 'Instance Methods' do
    subject {the_instance}
    it {should respond_to :score}
    it {should respond_to :score_list}
  end

  describe 'scoring a list' do
    it 'iterates over list' do
      fake_list.should_receive(:each)
      the_instance.score_list
    end

    it 'calls score on each item' do
      fake_list.each {|fake_item|
        the_instance.should_receive(:score).with(fake_item).and_return(0)
      }
      the_instance.score_list
    end

  end

  describe 'the cutoff' do
    it 'doesnt return items that are scored below a certain threshold' do
      cutoff = 1
      i = 0
      a_list = [{:a =>'a'}, {:b=>'b'}, {:c=>'c'}]
      #           0            1            2
      the_class.any_instance.stub(:score) { i+=1 }
      the_class.score(a_list, fake_term, cutoff).length.should be 2

      cutoff = 2
      i = 0
      the_class.score(a_list, fake_term, cutoff).length.should be 1
    end
  end

  describe 'returning a Result object' do
    it "returns a 'Result' object" do
      the_instance.score_list.first.should be_a Result
    end
    it "returns a 'Result' object with a score set" do
      the_instance.score_list.first.score.should == 1
    end
  end
end
