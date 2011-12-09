require './spec/spec_helper'
describe Correction do
  it 'takes two arguments' do
    Correction.new('a', 'b')
  end
  it 'has one original' do
    Correction.new('a', 'b').original.should == 'a'
  end
  it 'has one replacement' do
    Correction.new('a', 'b').replacement.should == 'b'
  end

end