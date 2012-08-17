require 'spec_helper'
module Alf
  class Aggregator
    describe Concat do

      let(:rel){[
        {:qty => 10}, 
        {:qty => 20},
        {:qty => 30},
        {:qty => 40}
      ]}

      it 'should work when used standalone' do
        Concat.new{ qty }.aggregate([]).should eq("")
        Concat.new{ qty }.aggregate(rel).should eq("10203040")
      end

      it 'should install factory methods' do
        Aggregator.concat{ qty }.should be_a(Concat)
        Aggregator.concat{ qty }.aggregate(rel).should eq("10203040")
      end

      it 'should work with options' do
        options = {:before => "bef", :after => "aft", :between => " bet "}
        expected = "bef10 bet 20 bet 30 bet 40aft"
        Aggregator.concat(options){ qty }.aggregate(rel).should eq(expected)
      end

    end
  end
end 
