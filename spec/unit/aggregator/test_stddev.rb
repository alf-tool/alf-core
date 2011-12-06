require 'spec_helper'
module Alf
  class Aggregator
    describe Stddev do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 20},
        {:qty => 30},
        {:qty => 40}
      ]}
      let(:expected) {
        Math.sqrt(Variance.new{qty}.aggregate(rel))
      }

      it 'should work when used standalone' do
        Stddev.new{ qty }.aggregate(rel).should eq(expected)
      end

      it 'should install factory methods' do
        Aggregator.stddev{ qty }.should be_a(Stddev)
        Aggregator.stddev{ qty }.aggregate(rel).should eq(expected)
      end

    end
  end
end 
