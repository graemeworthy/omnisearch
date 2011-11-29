require './spec/spec_helper'

describe "Engines::Plain" do
let(:the_class) {Engines::Plain}
describe 'Constants'do
  it 'INDEX should point at the plain index' do
    the_class::INDEX.should == OmniSearch::Indexes::Plain
  end
end

end
describe "Engines::Plain::Base" do

  let(:the_instance) {Engines::Plain::Base.new}
  let(:the_class) {Engines::Plain::Base}
  let(:fake_index) {{
    :fake_category => [
      {:id => 1, :value => 'puppies'},
      {:id => 2, :value => 'kittens'},
      {:id => 3, :value => 'apples'},
      {:id => 4, :value => 'oranges'},
      ]
   }}
 
  describe 'The Big Picture' do
    it "scores all items in an index, dropping those below cutoff" do
      the_instance.stub(:index) {fake_index}

       the_instance.stub(:cutoff) {3}
       counter = 0

       the_instance.stub(:score) {
         counter += 1
       }

       the_instance.results.should == {
        :fake_category=>
          [
            {:id=>4, :value=>"oranges", :score=>4},
            {:id=>3, :value=>"apples", :score=>3}
          ]
        }

    end
  end
  describe 'Interfaces' do
    
    it '#score should raise notImplemented' do
     expect { the_instance.score('') }.to raise_error
    end
    it '#cutoff should raise notImplemented' do
      expect { the_instance.cutoff }.to raise_error
      
    end    
  end
  describe 'Constructor' do
    it '@string is the argument' do
      argument = 'some string'
      an_instance = the_class.new(argument)
      an_instance.string.should == argument
    end
  end
  describe 'results' do
    it 'returns the scored_index' do
      the_instance.should_receive(:score_index)
      the_instance.results      
    end
  end
  describe 'index' do
    it 'returns the contents of of INDEX' do
      dummy_index = double()
      OmniSearch::Indexes::Plain.should_receive(:new).and_return(dummy_index)
      dummy_index.should_receive(:contents).and_return({})
      the_instance.send(:index)
    end
  end
  describe 'the scoring' do
    before(:each) do
      the_instance.stub(:index) {fake_index}
      the_instance.stub(:cutoff) {0}      
      the_instance.stub(:score) {1}    
    end
    
    describe 'score_index' do
      it 'scores, sorts and trims the contents of each category' do
        the_instance.should_receive(:score_items)
        the_instance.should_receive(:sort_items)
        the_instance.should_receive(:trim_below_cutoff)
        the_instance.send(:score_index)
      end
    end

    describe 'score_items' do
      it 'takes an array as an argument' do
        the_instance.send(:score_items, [])      
      end

      it 'calls score_item on each item' do
        one = double()
        two = double()
        items = [one, two]
        the_instance.should_receive(:score_item).with(one)
        the_instance.should_receive(:score_item).with(two)
        the_instance.send(:score_items, items)      
      end
     
    end
    describe 'score_item' do
      # this requires score_item to be defined
      it 'sets :score, to be the result of score on item[field]' do 
          item = {:id => 1, :value => 'pants'}        
          the_instance.send(:score_item, item)
          item.keys.include?(:score).should == true
      end
    end
    describe 'trim below cutoff' do
      it 'removes all items whose scores are below cutoff' do
        # down with pants, up with skirts!
        below = {:id => 1, :value => 'pants', :score => -1}
        above = {:id => 2, :value => 'skirts', :score => 1}
        items = [below, above]
        the_instance.send(:trim_below_cutoff, items)
        
        items.should == [above]        
      end
    end
    describe 'sort_items' do
      it 'sorts all items by score' do
        bottom = {:id => 3, :value => 'pancakes', :score =>  1}
        middle = {:id => 1, :value => 'waffles', :score => 2}
        top    = {:id => 2, :value => "waffles with icecream", :score => 3}
        items = [middle, top, bottom]
        the_instance.send(:sort_items, items)
        items.should ==  [top, middle, bottom]
        items.should_not == [middle, bottom, top]
        

      end
    end
  end
end


