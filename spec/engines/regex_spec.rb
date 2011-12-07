require './spec/spec_helper'

describe "Engines::Regex" do
  let(:fake_list)    {[
      {:id => 1, :value => 'puppies'},
      {:id => 2, :value => 'kittens'},
      {:id => 3, :value => 'apples'},
      {:id => 4, :value => 'oranges'},
      ]
   }
  let(:the_class) {Engines::Regex}

  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff" do
       the_class.new(fake_list, 'pup').score_list.should ==
       [
           {:id => 1, :value => 'puppies', :score => 1},
           {:id => 2, :value => 'kittens', :score => 0},
           {:id => 3, :value => 'apples',  :score => 0},
           {:id => 4, :value => 'oranges', :score => 0},
       ]

    end
  end
end
