require 'spec_helper'
module Alf
  class Aggregator
    describe Sum do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 20}
      ]}

      it 'should work when used standalone' do
        Sum.new{ qty }.aggregate([]).should eq(0)
        Sum.new{ qty }.aggregate(rel).should eq(30)
      end

      it 'should install factory methods' do
        Aggregator.sum{ qty }.should be_a(Sum)
        Aggregator.sum{ qty }.aggregate(rel).should eq(30)
      end

    end
  end
end 
