require 'spec_helper'
module Alf
  module Engine
    describe Summarize::Cesure do

      let(:input) {[
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 2},
        {:a => "via_reader", :time => 4},
        {:a => "via_reader", :time => 2},
      ]}

      let(:expected) {[
        {:a => "via_method", :time_sum => 4, :time_max => 2},
        {:a => "via_reader", :time_sum => 6, :time_max => 4},
      ].to_set}

      let(:aggs){Summarization.new(
        :time_sum => Aggregator.sum{ time },
        :time_max => Aggregator.max{ time }
      )} 

      it 'should summarize as expected' do
        sum = Summarize::Hash.new(input, AttrList[:a], aggs, false)
        sum.to_set.should eq(expected)
      end

      it 'should support allbut summarization' do
        sum = Summarize::Hash.new(input, AttrList[:time], aggs, true)
        sum.to_set.should eq(expected)
      end

    end 
  end
end
