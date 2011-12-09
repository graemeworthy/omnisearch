require './spec/spec_helper'
describe ResultSet::Factory do
    
  let(:demo) {
    # a reset
     list = Indexes::Plaintext.list
     list << PhysicianIndex
     list << ServiceIndex
     list << LocationIndex
     Indexes::Plaintext.list
     Indexes::Plaintext.class_variable_set(:@@contents, Hash.new)
    # a reset
    ResultSet::Factory.sets(Indexes::Plaintext, Engines::Regex, 'al', 0)
    }
  subject {demo}

  it 'should return an array' do
    subject.should be_an Array
  end

  it 'should return an array of ResultSets' do    
    subject.first.should be_a ResultSet
  end

  it 'should not return an empty ResultSets' do
    sets = ResultSet::Factory.sets(Indexes::Plaintext, Engines::Regex, 'alb', 0)
    sets.length.should be 1
  end


end

