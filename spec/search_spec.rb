require './spec/spec_helper'

describe Search do
  let(:the_class) {Search}
  let(:the_instance) {Search.new()}
  describe 'Class Methods' do
    subject {the_class}
    it {should respond_to :find}
  end
  describe 'Find' do
    it 'should return a results object' do
      Search.find('some term').should be_a Results
    end
  end
end

