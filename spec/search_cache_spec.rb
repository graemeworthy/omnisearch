# encoding: UTF-8
require './spec/spec_helper'
require 'benchmark'

describe Search::Cache do
    let(:the_term) { 'lorem' } # known good term look in the /spec indexes dir

    it 'should have loaded the indexes' do
      OmniSearch::Indexes.list.clear
      OmniSearch::Indexes.list << LocationIndex
      OmniSearch::Indexes.list.should == [LocationIndex]
    end

    it 'should return some results in cache_free mode' do
      Search.new(the_term).result_sets.should_not == []
    end

    describe 'Objects returned from cache' do
      before(:all) do
        Cache::QueryCache.refresh
        @no_cache_return = Search.new(the_term)
        @first_return    = Search::Cached.find(the_term)
        @second_return   = Search::Cached.find(the_term)
      end

      def compare_two_search_results(a, b)
        a_first = a.result_sets.last.results.first
        b_first = b.result_sets.last.results.first

        a.term.should == b.term
        a_first.class.should == b_first.class
        a_first.value.should == b_first.value
        a_first.label.should == b_first.label

        a.result_sets.first.results.first.value.should ==
          b.result_sets.first.results.first.value

      end

      it 'uncached results should be the same as cached' do
        compare_two_search_results(@no_cache_return, @first_return)
        # @no_cache_return.result_sets.last.klass.should == LocationIndex
        # @first_return.result_sets.last.klass.should == LocationIndex
      end

      it 'first and second queries should be the same too' do
        compare_two_search_results(@first_return, @second_return)
      end

    end

    # describe 'benchmark cache' do
    #   it 'should be faster than without' do
    #     # otherwise, why are we doing this?
    #     without_cache = Benchmark.realtime do
    #       1000.times { Search.new(the_term) }
    #     end
    #     Cache::QueryCache.refresh

    #     without_precache = Benchmark.realtime do
    #       1000.times { Search::Cached.find(the_term) }
    #     end

    #     Search::Cached.find(the_term)

    #     with_precache = Benchmark.realtime do
    #       1000.times { Search::Cached.find(the_term) }
    #     end

    #     without_cache.should be > without_precache
    #     without_cache.should be > with_precache
    #   end

    # end
  end