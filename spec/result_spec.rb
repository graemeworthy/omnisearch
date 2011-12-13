require './spec/spec_helper'

describe Result do
  let(:the_class) {Result}
  subject { Result.new(:label => "A result", :score => 1) }

  describe "Instance Methods" do
    it {should respond_to :id}
    it {should respond_to :klass}
    it {should respond_to :raw_data}
    it {should respond_to :score}
    it {should respond_to :value}
  end

  it 'takes a hash as its argument' do
    the_class.new({}).should be
  end

  it 'exposes a lot of passed arguments' do
    the_class.new({:id => 'this'}).id.should eq 'this'
    the_class.new({:klass => 'this'}).klass.should eq 'this'
    the_class.new({:score => 'this'}).score.should eq 'this'
  end

  it 'exposes hash[:label] as value, on purpose' do
    the_class.new({:label => 'this', :value => 'that'}).value.should eq 'this'
    the_class.new({:label => 'this', :value => 'that'}).label.should eq 'this'
  end

  it 'passes any other .something calls down to the raw_data' do
    the_class.new({:thumbnail => 'this'}).thumbnail.should eq 'this'
  end

end
