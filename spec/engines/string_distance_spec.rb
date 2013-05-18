require './spec/spec_helper'
describe "Engines::StringDistance" do
  let(:fake_list)    {[
                        {:id => 1, :value => 'puppies'},
                        {:id => 2, :value => 'kittens'},
                        {:id => 3, :value => 'apples'},
                        {:id => 4, :value => 'oranges'},
  ]}
  let(:the_class) {Engines::StringDistance}

  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff" do
      the_class.new(fake_list, 'pup').score_list.length.should == 1
      the_class.new(fake_list, 'pup').score_list.first.id.should == 1
      the_class.new(fake_list, 'pup').score_list.first.score.should == 0.6
    end
  end
end
