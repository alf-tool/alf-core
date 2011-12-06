require 'spec_helper'
module Alf
  class Aggregator
    describe Avg do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 1}
      ]}

      it 'should work when used standalone' do
        Avg.new{ qty }.aggregate(rel).should eq(5.5)
      end

      it 'should install factory methods' do
        Aggregator.avg{ qty }.should be_a(Avg)
        Aggregator.avg{ qty }.aggregate(rel).should eq(5.5)
      end

    end
  end
end 
