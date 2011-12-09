require './spec/spec_helper'
class Physician
end
class PhysicianIndex
  indexes :physician
end

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
  
  it "should have a label which is pluralized class name" do
    subject.label.should eq 'Physicians'
  end

  it "should have an indexed_klass which is what it indexes" do
    subject.send(:indexed_klass).should eq Physician
  end

  it 'should have an array of Results under results' do
    subject.results.should be_an Array
    subject.results.first.should be_a Result
  end

  it 'brands all of its result children with the index_name of the indexed class' do
    a_result = Result.new({})
    a_result_set = ResultSet.new(PhysicianIndex, [a_result])
    branded_result = a_result_set.results.first
    branded_result.klass.should == Physician
    
    
  end
end
