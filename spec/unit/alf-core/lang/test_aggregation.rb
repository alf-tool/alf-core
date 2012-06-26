require 'spec_helper'
module Alf
  module Lang
    describe Aggregation do
      include Aggregation

      let(:input){[
        {:tested => 1,  :other => "b"},
        {:tested => 30, :other => "a"},
      ]}

      let(:expected){[
        {:tested => 30, :other => "a", :upcase => "A"},
      ]}

      it "should have sum" do
        sum{ qty }.should be_a(Aggregator::Sum)
      end

      it "should have stddev aggregator" do
        stddev{ qty }.should be_a(Aggregator::Stddev)
      end

    end
  end
end