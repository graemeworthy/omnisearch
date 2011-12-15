require './spec/spec_helper'

class PhysicianDemo
end
class PhysicianDemoIndex
  include OmniSearch::Indexes::Register
  indexes     :physician_demo

  def extended_results_for(winner)
    [{:id => 1, :label => 'i am an extended result'}]
  end
end

describe ResultSet::Extended do
  let(:demo_index) {PhysicianDemoIndex}
  let(:example_set) {
    ResultSet.new(PhysicianDemoIndex, [example_result])
  }
  let(:example_result)  {Result.new(:id => 1, :value => 'something', :score => 1)}
  let(:example_results) {[example_set]}

  let(:the_class) {ResultSet::Extended}
  let(:the_instance) {ResultSet::Extended.new(example_results)}

  describe 'The Constructor' do
    it 'takes an array of resultSets' do
      the_class.new(example_results)
    end
  end
  describe 'Class Methods' do
    it '#find proxies .new(args).extended_results' do
      instance = double()
      args = ['something']
      the_class.should_receive(:new).with(args).and_return(instance)
      instance.should_receive(:extended_results)

      the_class.find(args)
    end
  end

  describe 'Instance Methods' do
    it 'winner? is true if there is only one result' do
      the_instance.winner?.should == true
    end

    it 'winner? is false if there is more than one result' do
      no_winner_instance = the_class.new([example_set, example_set])
      no_winner_instance.winner?.should == false
    end

    it 'winner should return the winner' do
      the_instance.winner.should == example_result
    end

    it 'winner should return nil, if no winner' do
      no_winner_instance = the_class.new([example_set, example_set])
      no_winner_instance.winner.should be nil
    end

    it 'extended_results should return default_result, if no winner' do
      no_winner_instance = the_class.new([example_set, example_set])
      no_winner_instance.extended_results.should == no_winner_instance.default_result
    end

    it 'default result should be []' do
      the_instance.default_result.should == []
    end

  end


  #the results of these are indexed in a funny way, they use a 'name'
  # why not use a constant as the key!?

  describe 'backmapping to a class' do
    it 'winner_index instantiates the winning class' do
      the_instance.winner_index.should be demo_index
    end
  end

  describe 'using the extended_results finder from that class' do
    it 'winner_index instantiates the winning class' do
      the_instance.winner_index.should be demo_index
    end

    it 'that class should recieve a call to extended results' do
      demo_index = double()
      PhysicianDemoIndex.should_receive(:new).and_return(demo_index)
      demo_index.should_receive(:extended_results_for)
      the_instance.extended_results
    end
    it 'should delegate to the indexed class' do
      the_instance.extended_results.should ==  [{:id => 1, :label => 'i am an extended result'}]
    end

    it 'should rescue a notImplemented and pass it to default' do
      demo_index = double()
      demo_index.stub(:extended_results_for) {raise NotImplementedError}
      PhysicianDemoIndex.should_receive(:new).and_return(demo_index)
      the_instance.should_receive(:default_result)

      the_instance.extended_results
    end
  end

end
