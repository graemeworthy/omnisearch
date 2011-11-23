require './spec/spec_helper'

describe "Engines::Regex" do
  let(:the_instance) {Engines::Regex.new('')}
  it 'defines score' 
  it 'defines cutoff' 
  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff, highlighting the top ones" do
      the_instance.stub(:index) {{

        :fake_index => [
          {:id => 1, :value => 'puppies'},
          {:id => 2, :value => 'kittens'},
          {:id => 3, :value => 'apples'},
          {:id => 4, :value => 'oranges'},
          ]
       }}

       the_instance.string = 'pup'

       the_instance.results.should == {
        :fake_index=>
          [
            {:id => 1, :value => 'puppies', :score => 1},
          ],
        :top_hit=>
          [
            {:id => 1, :value => 'puppies', :score => 1},
          ]
        }

    end
  end
  
  
end
