require './spec/spec_helper'

describe Search do
  let(:the_term)           {'some term'}
  let(:the_correction)     {'some correction'}
  let(:the_class)    {Search}
  let(:the_instance) {Search.new('some term')}


  describe 'Instance Methods' do
    subject {the_instance}
    it {should respond_to :correction}
    it {should respond_to :result_sets}
    it {should respond_to :extended_result_sets}
  end

  describe 'AutoCorrection' do
    it 'should look for a correction in AutoCorrect' do
      AutoCorrect.should_receive(:for).with(the_term)
      Search.new(the_term)
    end

    it 'should return a Correction if there is one' do
      AutoCorrect.add(the_term, the_correction)
      the_instance.correction.should be_a Correction
    end

    it 'should store the original in @original' do
      the_instance.original.should == the_term
    end

    it 'should update @term' do
      the_instance.term.should == the_correction
    end

    it 'should return nil if there is not' do
      AutoCorrect.remove('some term')
      the_instance.correction.should be nil
    end
  end

  describe 'Result Sets' do

    it 'should return an array for result_sets' do
      the_instance.result_sets.should be_an Array
    end

    it 'should return an array for extended_result_sets' do
      the_instance.extended_result_sets.should be_an Array
    end

  end
end

