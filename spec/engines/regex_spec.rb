require './spec/spec_helper'

describe "Engines::Regex" do
  let(:fake_list)    {[
                        {:id => 1, :value => 'puppies'},
                        {:id => 2, :value => 'kittens'},
                        {:id => 3, :value => 'apples'},
                        {:id => 4, :value => 'oranges'},
  ]}
  let(:the_class) {Engines::Regex}

  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff" do
      the_class.new(fake_list, 'pup').score_list.length.should be 1
      the_class.new(fake_list, 'pup').score_list.first.id.should be 1
    end
  end

  describe 'An error case, caught' do
    it "term set to nil" do
      lambda {the_class.new(fake_list, nil).score_list}.should_not raise_error
    end
  end
end
