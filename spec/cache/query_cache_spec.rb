# encoding: UTF-8
require './spec/spec_helper'

describe Cache::QueryCache do

  let(:a_key)            { 'something' }
  let(:a_namespaced_key) { "query_cache:#{a_key}" }
  let(:a_value)          { 'a complicated return object' }
  let(:the_class)        { Cache::QueryCache }
  let(:cache_instance)   { Cache.instance }

  describe 'Class Methods' do

    describe '##namespace_key' do
      it 'should take a string' do
        the_class.namespace_key(a_key)
      end

      it 'should return a string with "query_cache" attached' do
        the_class.namespace_key(a_key).should == a_namespaced_key
      end
    end

    describe '##read' do
      it 'should call #read on the cache instance' do
        cache_instance.should_receive(:read).with(a_namespaced_key)
        the_class.read(a_key)
      end
    end

    describe '##write' do
      it 'shold call #write on the cache instance' do
        cache_instance.should_receive(:write).with(a_namespaced_key, a_value)
        the_class.write(a_key, a_value)
      end

    end
end
end
