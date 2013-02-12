require './spec/spec_helper'

describe ResultSet::More do

  let(:the_class) {ResultSet::More}
  subject{ the_class.make('sausages')}


  it {should be_a ResultSet}

  it 'should pass the special type "search_more"' do
    subject.special_type.should == :search_more
  end


end
