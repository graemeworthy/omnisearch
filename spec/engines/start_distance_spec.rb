require './spec/spec_helper'

describe "Engines::StartDistance" do
  let(:the_instance) {Engines::StartDistance.new('')}
  it 'defines score'
  it 'defines cutoff'
  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff, highlighting the top ones" do
      the_instance.stub(:index) {{

        :fake_index => [
          {:id => 1, :value => 'puppies'},
          {:id => 2, :value => 'kittens'},
          {:id => 3, :value => 'rug puppies'},
          {:id => 4, :value => 'oranges'},
          ]
       }}

       the_instance.string = 'pup'

       the_instance.results.should == {
        :fake_index=>
          [
            {:id => 1, :value => 'puppies', :score => 1},
            {:id => 3, :value => 'rug puppies', :score => 0.2},
          ],
        :top_hit=>
          [
            {:id => 1, :value => 'puppies', :score => 1},
          ]
        }

    end
  end


end
