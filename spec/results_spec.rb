require './spec/spec_helper'

describe Results do
  let (:the_class) {Results}
  let (:the_instance) {Results.new({})}
  describe 'Class Methods' do

  end
  describe 'Instance Methods' do
    subject {the_instance}
    it {should respond_to :searching_as }
    it {should respond_to :results }
    it {should respond_to :extended_results}
  end
end
