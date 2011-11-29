require './spec/spec_helper'

class PhysicianDemoIndex
  def extended_results_for(winner)
    [{:id => 1, :label => 'i am an extended result'}]
  end
end

describe Results::Extended do
  let (:demo_index) {PhysicianDemoIndex}
  let (:example_results) {{
    PhysicianDemoIndex => [
      {:id => 1, :value => 'something'}
      ]
  }}
  
  let (:the_class) {Results::Extended}
  let (:the_instance) {Results::Extended.new(example_results)}

  describe 'The Constructor' do
    it 'takes a hash set of results' do
      the_class.new(example_results)
    end
  end
  describe 'Instance Methods' do
    it 'winner? is true if there is only one result' do
      the_instance.winner?.should == true
    end
    it 'winner? is false if there is more than one result' do
      no_winner_instance = the_class.new({demo_index => [
        {:id => 1, :value => 'something'},
        {:id => 2, :value => 'something_else'}
        ]})
      no_winner_instance.winner?.should == false
    end        
    it 'winner is false if there is more than one result' do
      the_instance.winner.should == {:id => 1, :value => 'something'}
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
