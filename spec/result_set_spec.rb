require './spec/spec_helper'

class Physician
end

class PhysicianIndex
  def self.index_name
    "physician"
  end
end

describe ResultSet do
  let(:a_result) { Result.new({})}
  let(:demo)  {ResultSet.new(PhysicianIndex, [a_result])}
  let(:demo2) {ResultSet.new(Physician, [a_result])}

  subject {demo}

  it 'should be a ResultSet' do
    subject.should be_an ResultSet
  end

  it 'should have a count of results' do
    subject.count.should == 1
  end

  it 'should have a klass' do
    subject.klass.should be PhysicianIndex
  end

  it "should have a label which is pluralized class name" do
    subject.label.should eq 'Physicians'
  end

  describe 'label' do

    it "is normally a pluralized class name" do
      subject.label.should eq 'Physicians'
    end

    it "can be 'Top Hit'" do
      label = ResultSet.new(Physician, [a_result], :top_hit).label
      label.should == 'Top Hit'
    end
    it "can be 'Site Search'" do
      label = ResultSet.new(Physician, [a_result], :search_more).label
      label.should == 'Site Search'
    end
  end


  it "should have an indexed_klass which is what it indexes" do
    subject.send(:indexed_klass).to_s.should eq "Physician"
  end

  it "if there is an index name" do
    demo.send(:indexed_klass).to_s.should eq "Physician"
    demo2.send(:indexed_klass).to_s.should eq "Physician"

  end

  it 'should have an array of Results under results' do
    subject.results.should be_an Array
    subject.results.first.should be_a Result
  end

  it 'brands all its result children with index_name of the indexed class' do
    a_result_set = ResultSet.new(PhysicianIndex, [a_result])
    branded_result = a_result_set.results.first
    branded_result.klass.should == "Physician"
  end
end
