# encoding: UTF-8
require './spec/spec_helper'

describe Cache::Base do
  let(:a_key)          {'something'}
  let(:a_value)        {'a complicated return object'}
  let(:the_class)      {Cache::Base}
  let(:cache_instance) {Cache.instance}

  describe 'Class Methods' do

    describe '##namespace_key' do
      it 'should take a string' do
        the_class.namespace_key(a_key)
      end

      it 'should return a string' do
        the_class.namespace_key(a_key).should be_a String
      end
    end

    describe '##read' do
      it 'should call #read on the cache instance' do
        cache_instance.should_receive(:read)
        the_class.read(a_key)
      end

      it 'should return nil if there is a cache error' do
        cache_instance.should_receive(:read).
        and_raise(MemCache::MemCacheError)

        the_class.read(a_key).should be_nil
      end

      it 'should still raise if there is some other error' do
        cache_instance.should_receive(:read).
          and_raise(ArgumentError)

        expect{ the_class.read(a_key) }.to raise_error(ArgumentError)
      end
    end

    describe '##write' do
      it 'shold call #write on the cache instance' do
        cache_instance.should_receive(:write).with(a_key, a_value)
        the_class.write(a_key, a_value)
      end

      it 'should return the value if there is a cache error' do
        cache_instance.should_receive(:write).with(a_key, a_value).
          and_raise(MemCache::MemCacheError)

        the_class.write(a_key, a_value).should == a_value
      end

      it 'should still raise if there is some other error' do
        cache_instance.should_receive(:write).with(a_key, a_value).
          and_raise(ArgumentError)

        expect{ the_class.write(a_key, a_value) }.to raise_error(ArgumentError)
      end
    end

    describe '##clear' do
      it 'should call #clear on the cache instance' do
        cache_instance.should_receive(:clear)
        the_class.clear
      end
       it 'should recover from a cache error' do
        cache_instance.should_receive(:clear).
          and_raise(MemCache::MemCacheError)

        expect{ the_class.clear}.to_not raise_error
      end
    end
  end
end

