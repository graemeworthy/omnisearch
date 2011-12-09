require './spec/spec_helper'

describe ResultSet do
  let(:demo) {ResultSet::Factory.sets(Indexes::Plaintext, Engines::Regex, 'al', 0).first}
  subject {demo}

  it 'should be a ResultSet' do
    subject.should be_an ResultSet
  end

  it 'should have a klass' do
    # bad test
    subject.klass.should be PhysicianIndex
  end
  
  it "should have a label" do
    subject.label.should eq 'Physician'
  end

  it 'should have an array of Results under results' do
    subject.results.should be_an Array
    subject.results.first.should be_a Result
  end

end
