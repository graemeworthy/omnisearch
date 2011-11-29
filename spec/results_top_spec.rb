require './spec/spec_helper'

describe Results::Top do
  let (:the_class) {Results::Top}
  let (:the_instance) {Results::Top.new({})}
  describe 'The Constructor' do
    it 'takes a hash set of results'
  end
  describe 'Class Methods' do
    it 'exposes #find on the class' do
    end

  end
  describe 'Instance Methods' do
    it 'find_top returns the top item' do
    end
    it 'inspects as a hash' do
      the_instance.inspect.should == []
    end
  end
end
