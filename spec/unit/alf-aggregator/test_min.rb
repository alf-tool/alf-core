require 'spec_helper'
module Alf
  class Aggregator
    describe Min do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 0}
      ]}

      it 'should work when used standalone' do
        Min.new{ qty }.aggregate([]).should eq(nil)
        Min.new{ qty }.aggregate(rel).should eq(0)
      end

      it 'should install factory methods' do
        Aggregator.min{ qty }.should be_a(Min)
        Aggregator.min{ qty }.aggregate(rel).should eq(0)
      end

    end
  end
end 
