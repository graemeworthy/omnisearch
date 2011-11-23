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


describe 'A working Example' do
  before(:all) do
    #first we set up the Index, Builder and Storage classes
    class DemoIndex < OmniSearch::Indexes
      # this holds the subindex list
    end
      # this sets up the storage locations
    class DemoIndex::Storage < OmniSearch::Indexes::Storage::Plain
      BASE_FILENAME = 'omnisearch_demo_index'
      PATH = './spec/examples/'
    end
      # this links the storage and the master index
    module DemoIndex::Builder
      include OmniSearch::Indexes::Builder::Base
      STORAGE_ENGINE = DemoIndex::Storage
      MASTER_INDEX   = DemoIndex
    end
     # then we set up the search indexes
     # one
     class PhysicianIndex
       include DemoIndex::Builder
       def index_name
           'physician'
       end
     end
     # two
     class ServiceIndex
       include DemoIndex::Builder
       def index_name
           'service'
       end
     end
     # three
     class LocationIndex
       include DemoIndex::Builder
       def index_name
           'location'
       end
     end
     # the search tools have to be configured to use the demo indexes
     # silently
     silently {OmniSearch::Engines::Plain::INDEX = DemoIndex}
  end
  it 'has a list of indexes' do
    DemoIndex.list.length.should == 3
    DemoIndex.list.first.should be_a PhysicianIndex
    DemoIndex.list[1].should    be_a ServiceIndex
    DemoIndex.list.last.should  be_a LocationIndex
  end
  it 'has a contents for those indexes' do
    # the demo indexes contain ten items each
    DemoIndex.new.contents.each {|k, v|
      v.length.should == 10
     }
  end
  it 'can search those indexes' do
    # the demo indexes contain ten items each
    OmniSearch::Engines::Regex.new('abcde').results.should ==
      { "physician"=>[],
        "service"=>[],
        "location"=>[
            {:id=>1, :value=>"abcdefg", :label=>"ABCDEFG", :score=>1}
         ],
        :top_hit=>[
           {:id=>1, :value=>"abcdefg", :label=>"ABCDEFG", :score=>1}
         ]
      }
  end
  it "doesn't nuke the index to do a search" do
    # the demo indexes contain ten items each
    DemoIndex.new.contents.each {|k, v|
      v.length.should == 10
     }
  end
  it "Can search from OmniSearch::Search" do
    results = OmniSearch::Search.find('abcde')
    results.
  end


end
