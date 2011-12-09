require './spec/spec_helper'

describe Result do
  
  subject { Result.new(:label => "A result", :score => 1) }

  it 'should have a label' do
    subject.label.should == "A result"
  end

end