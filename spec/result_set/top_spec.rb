require './spec/spec_helper'

class PizzaIndex; end
class PantherIndex; end
class PredatorIndex; end
#

describe ResultSet::Extended do
  let(:top) {Result.new(:id => 1, :value => 'something', :score => 120)}
  let(:example_results) {
    [
      ResultSet.new(PhysicianIndex,
      [
        Result.new(:id => 1, :value => 'something', :score => 12),
        Result.new(:id => 1, :value => 'something', :score => 10),
      ]
      ),
      ResultSet.new(LocationIndex,
      [
        top,
        Result.new(:id => 1, :value => 'something', :score => 11),
      ]
      ),
      ResultSet.new(ServiceIndex,
      [
        Result.new(:id => 1, :value => 'something', :score => 13),
        Result.new(:id => 1, :value => 'something', :score => 12),
      ]
      )
    ]
  }

  let(:the_class) {ResultSet::Top}
  let(:the_instance) {ResultSet::Top.new(example_results)}

  it 'sorts through them and grabs the best one' do
    the_class.find(example_results).results.should ==  [top]
  end

  it 'returns a result set with top_hit set' do
    the_class.find(example_results).top_hit?.should == true
  end

  it "should have a label 'Top Hit'" do
    the_class.find(example_results).label == 'Top Hit'
  end

end
