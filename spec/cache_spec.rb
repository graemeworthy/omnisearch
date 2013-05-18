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
    describe 'self.refresh' do
        it 'should call clear on the instance' do
            Cache.instance.should_receive(:refresh)
            Cache.refresh
        end
        it 'should update the timestamp' do
           old_time = Time.local(2008, 9, 1, 12, 0, 0)
           new_time = Time.local(2009, 9, 1, 12, 0, 0)
           Timecop.travel(old_time)
           Cache.refresh
           old_stamp   = Cache.instance.timestamp
           Timecop.travel(new_time)
           check_stamp = Cache.instance.timestamp
           old_stamp.should == check_stamp

           Cache.refresh
           new_stamp = Cache.instance.timestamp
           new_stamp.should_not == old_stamp
           Timecop.return
        end
    end
end

