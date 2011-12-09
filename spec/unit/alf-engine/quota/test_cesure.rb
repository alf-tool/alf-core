require 'spec_helper'
module Alf
  module Engine
    describe Quota::Cesure do

      let(:input) {[
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 2},
        {:a => "via_method", :time => 3},
        {:a => "via_reader", :time => 2},
        {:a => "via_reader", :time => 4},
      ]}

      let(:expected) {[
        {:a => "via_method", :time => 1, :time_sum => 1, :time_max => 1},
        {:a => "via_method", :time => 2, :time_sum => 3, :time_max => 2},
        {:a => "via_method", :time => 3, :time_sum => 6, :time_max => 3},
        {:a => "via_reader", :time => 2, :time_sum => 2, :time_max => 2},
        {:a => "via_reader", :time => 4, :time_sum => 6, :time_max => 4},
      ]}

      it 'should compute as expected' do
        sums = Summarization[
          :time_sum => Aggregator.sum{ time },
          :time_max => Aggregator.max{ time }
        ]
        by    = AttrList[:a]
        op = Engine::Quota::Cesure.new(input, by, sums)
        op.to_a.should eq(expected)
      end

    end
  end
end
