require 'spec_helper'
module Alf
  class Aggregator
    describe Count do

      it 'should work when used standalone' do
        Count.new.aggregate([]).should eq(0)
        Count.new.aggregate([{}]).should eq(1)
      end

      it 'should install factory methods' do
        Aggregator.count.should be_a(Count)
      end

    end
  end
end 
