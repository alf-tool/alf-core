require 'spec_helper'
module Alf
  class Aggregator
    describe Max do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 0}
      ]}

      it 'should work when used standalone' do
        Max.new{ qty }.aggregate([]).should eq(nil)
        Max.new{ qty }.aggregate(rel).should eq(10)
      end

      it 'should install factory methods' do
        Aggregator.max{ qty }.should be_a(Max)
        Aggregator.max{ qty }.aggregate(rel).should eq(10)
      end

    end
  end
end 
