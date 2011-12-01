require './spec/spec_helper'
class PizzaIndex; end
class PantherIndex; end
class PredatorIndex; end

describe Results::Top do
  let (:the_class) {Results::Top}
  let (:the_instance) {Results::Top.new({})}
  describe 'the big picture' do
    let(:some_results) {{ 
            PizzaIndex => [
                {:score => 12}, 
                {:score => 10}
               ],
            PantherIndex => [
                {:score => 120}, 
                {:score => 11}
                ],
            PredatorIndex => [
                {:score => 12}, 
                {:score => 10}
               ],

              }}

    it 'takes a set of results' do
        the_class.new(some_results)
    end
    it 'returns sorts through them and grabs the best one' do
        the_class.find(some_results).should == {:score => 120}      
    end

  end
end
