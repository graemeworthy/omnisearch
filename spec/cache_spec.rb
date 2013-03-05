# encoding: UTF-8
require './spec/spec_helper'

describe OmniSearch::Cache do
    describe 'is a singleton' do
        it 'responds to instance' do
            Cache.should respond_to(:instance)
        end
        it 'returns the same instance every time' do
            Cache.instance.should == Cache.instance
        end
    end
end

