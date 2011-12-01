require './spec/spec_helper'

describe "Engines::StartDistance" do
  let(:the_instance) {Engines::StartDistance.new('')}
  it 'defines score' do
    expect { the_instance.score("") }.to_not raise_error
  end
  it 'defines cutoff' do
    expect { the_instance.cutoff }.to_not raise_error
  end

  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff" do
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
            {:id => 1, :value => 'puppies', :score => 0.996},
            {:id => 3, :value => 'rug puppies', :score => 0.996},
          ]
        }
    end
  end
end
