require './spec/spec_helper'

describe OmniSearch::Indexes::Fetcher do
  let(:the_class) { OmniSearch::Indexes::Fetcher }

  let(:example_index_class) { PhysicianIndex     }
  let(:example_index_type)  { Indexes::Plaintext }
  let(:dummy_record)        { ['dummy_record']   }
  let(:dummy_record2)       { ['dummy_record2']  }


  let(:an_instance) {
    OmniSearch::Indexes::Fetcher.new(
      example_index_class,
      example_index_type
    )
  }

  describe "Instance Methods" do

    describe  '#name' do
      it 'should call index_name on the indexed class' do
        example_index_class.should_receive(:index_name)
        an_instance.name
      end

      it 'should return the indexed classes index_name' do
        example_index_class.should_receive(:index_name).and_return('whut')
        an_instance.name.should == 'whut'
      end
    end

    describe '#cache_name' do
      it 'should be combo if index class and index type' do
        combo = 'OmniSearch::Indexes::Plaintext_PhysicianIndex'
        an_instance.cache_name.should == combo
      end
    end

    describe '#read_through_cache' do
      describe 'when there is a cached record' do
        before(:all) do
          an_instance.save_to_cache(dummy_record)
        end

        it 'should return the cached record' do
          an_instance.read_through_cache.should == dummy_record
        end

      end
      describe 'when there is not a cached record' do

        before(:each) {
          Cache.instance.clear
          an_instance.stub(:load).and_return(dummy_record2)
        }

        it 'should return the record from storage' do
          an_instance.read_through_cache.should == dummy_record2
        end

        it 'should cache the record' do
          an_instance.should_receive(:save_to_cache).
            with(dummy_record2).
            and_return(dummy_record2)
          an_instance.read_through_cache.should == dummy_record2
        end

        it 'should be readable from cache on the next pass' do
          an_instance.should_receive(:load).once.and_return(dummy_record2)
          an_instance.read_through_cache.should == dummy_record2
          an_instance.read_through_cache.should == dummy_record2
        end
      end
    end

    describe '#save_to_cache' do
      let(:the_payload) {'something'}
      before(:each) {
        Cache.instance.clear
      }

      it 'should take one argument ' do
        expect { an_instance.save_to_cache(the_payload) }.to_not raise_error
      end

      it 'should not take two arguments' do
        expect { an_instance.save_to_cache('a', 'b') }.to raise_error
      end

      it 'should save the passed object to the cache' do
        the_cache_name = an_instance.cache_name

        an_instance.cache.should_receive(:write).with(
          the_cache_name,
          the_payload
        )

        an_instance.save_to_cache(the_payload)
      end

      it 'should return the object' do
        an_instance.save_to_cache(the_payload).should == the_payload
      end

      it 'should now be retrieveable from cache' do
        an_instance.save_to_cache(the_payload)
        an_instance.read_cache.should == the_payload
      end
    end

    describe '#read cache' do
      it 'should return nil if there is nothing in the cache' do
        an_instance.cache.refresh
        an_instance.read_cache.should be nil
      end
      it 'should return the index we requested' do
        records = an_instance.records
        an_instance.read_cache.should == records
      end

      it 'should return the same kind of objects as load' do
        loaded_records = an_instance.load
        cached_records = an_instance.read_cache
        loaded_records.should == cached_records
      end
    end

    describe '#records' do
      it 'should call #read_through_cache' do
        an_instance.should_receive(:read_through_cache)
        an_instance.records
      end
      it 'should memoize the result' do
        an_instance.
          should_receive(:read_through_cache).
          once.
          and_return(dummy_record)
        an_instance.records
        an_instance.records
      end

    end

    describe '#storage' do
      it 'should ask the index_type for its storage engine' do
        example_index_type::STORAGE_ENGINE.should_receive(:new)
        an_instance.storage
      end
    end

    describe '#load' do
      it 'should load from storage' do
        name =   an_instance.name
        content = example_index_type::STORAGE_ENGINE.new(name).load
        an_instance.load.should == content
      end

    end

    describe '#load_to_cache' do
      it 'should load from storage' do
        an_instance.should_receive(:load).and_return(dummy_record)
        an_instance.load_to_cache
      end
      it 'should save to cache' do
        an_instance.cache.refresh
        an_instance.stub(:load).and_return(dummy_record)
        an_instance.load_to_cache
        an_instance.read_cache.should == dummy_record
      end
    end
  end

  describe "If memcache is down" do
     it 'should still load from disk' do
       fake_error = MemCache::MemCacheError.new('i am a fake error')

       Cache.instance.should_receive(:read).
         and_raise(fake_error)

       an_instance.stub(:load).and_return(dummy_record)
       an_instance.records.should == dummy_record
     end
  end


end
