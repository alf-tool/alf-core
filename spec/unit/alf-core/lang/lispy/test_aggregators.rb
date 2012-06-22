require 'spec_helper'
module Alf
  module Lang
    describe Lispy, "the aggregator functions" do

      let(:lispy){ Database.examples.lispy }

      let(:input){[
        {:tested => 1,  :other => "b"},
        {:tested => 30, :other => "a"},
      ]}

      let(:expected){[
        {:tested => 30, :other => "a", :upcase => "A"},
      ]}

      it "should have sum" do
        lispy.sum{ qty }.should be_a(Aggregator::Sum)
      end

      it "should have stddev aggregator" do
        lispy.stddev{ qty }.should be_a(Aggregator::Stddev)
      end

    end
  end
end