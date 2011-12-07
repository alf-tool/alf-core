require 'spec_helper'
module Alf
  class Aggregator
    describe Variance do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 20},
        {:qty => 30},
        {:qty => 40}
      ]}
      let(:expected) {
        vals = rel.map{|t| t[:qty]}
        mean = vals.inject(:+) / vals.size.to_f
        vals.collect{|v| (v - mean)**2 }.inject(:+) / vals.size.to_f
      }

      it 'should work when used standalone' do
        Variance.new{ qty }.aggregate(rel).should eq(expected)
      end

      it 'should install factory methods' do
        Aggregator.variance{ qty }.should be_a(Variance)
        Aggregator.variance{ qty }.aggregate(rel).should eq(expected)
      end

    end
  end
end 
