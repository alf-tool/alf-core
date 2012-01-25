require 'spec_helper'
module Alf
  describe Lispy do
    include Lispy

    let(:input){[
      {:tested => 1,  :other => "b"},
      {:tested => 30, :other => "a"},
    ]}

    let(:expected){[
      {:tested => 30, :other => "a", :upcase => "A"},
    ]}

    it "should allow chaining operators 'ala' LISP" do
      operator = (extend \
                   (restrict input, lambda{ tested > 10 }),
                   :upcase => lambda{ other.upcase })
      operator.to_a.should == expected
    end

    it "should allow building aggregators" do
      sum{ qty }.should be_a(Aggregator::Sum)
    end

    it "should have stddev aggregator" do
      stddev{ qty }.should be_a(Aggregator::Stddev)
    end

  end
end
