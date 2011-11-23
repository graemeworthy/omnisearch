require './spec/spec_helper'

describe "Engines::Plain::Base" do

  let(:the_instance) {Engines::Plain::Base.new}
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

       the_instance.stub(:cutoff) {3}
       counter = 0

       the_instance.stub(:score) {
         counter += 1
       }

       the_instance.results.should == {
        :fake_index=>
          [
            {:id=>4, :value=>"oranges", :score=>4},
            {:id=>3, :value=>"apples", :score=>3}
          ],
        :top_hit=>
          [
            {:id=>4, :value=>"oranges", :score=>4}
          ]
        }

    end
  end
  describe 'Constants'do
    it 'INDEX should point at an Index'
  end
  describe 'Interfaces' do
    it '#score should raise notImplemented'
    it '#cutoff should raise notImplemented'
  end
  describe 'Constructor' do
    it '@string is the argument'
    it '@top_score, begins at 0'
    it '@top_hit begins nil'
  end
  describe 'results' do
    it 'returns the scored_index'
    it "includes the top hit, if there is one"
    it "doesn't include the top_hit if there isn't one"
  end
  describe 'index' do
    it 'returns the contents of of INDEX'
    it 'memoizes the results'
  end
  describe 'score_index' do
    it 'scores the contents of each category'
    it 'sorts the contents of each category'
  end
  describe 'score_items' do
    it 'has a terrible name'
    it 'takes an array as an argument'
    it 'takes a  field as an argument, optionaly'
    it 'calls score_hash on each item'
    it 'calls top_test   on each item'
    it 'calls trim_below_cutoff, on the whole set'
  end
  describe 'score_item' do
    # this requires score_item to be defined
    it 'sets :score, to be the result of score on item[field]'
  end
  describe 'top_test' do
    it 'aborts if item[:score] below cutoff'
    it "bumps the top_hit, if it's better"
    it "bumps the top_hit, if it's equal"
    it "doesn't bump if it's not better"
  end
  describe 'trim below cutoff' do
    #this requires cutoff to be defined
    it 'removes all items whose scores are below cutoff'
  end
  describe 'sort_items' do
    it 'sorts all items by score'
  end
end


