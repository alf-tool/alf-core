require 'spec_helper'
module Alf
  class Aggregator
    describe Collect do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 20},
        {:qty => 30},
        {:qty => 40}
      ]}

      it 'should work when used standalone' do
        Collect.new{ qty }.aggregate([]).should eq([])
        Collect.new{ qty }.aggregate(rel).should eq([10,20,30,40])
      end

      it 'should install factory methods' do
        Aggregator.collect{ qty }.should be_a(Collect)
        Aggregator.collect{ qty }.aggregate(rel).should eq([10,20,30,40])
      end

    end
  end
end 
