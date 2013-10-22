require 'spec_helper'
module Alf
  describe Aggregator do

    let(:input){[
      {:a => 1, :sign => -1},
      {:a => 2, :sign => 1 },
      {:a => 3, :sign => -1},
      {:a => 1, :sign => -1},
    ]}

    it "should keep track of registered aggregators" do
      Aggregator.all.should be_a(Array)
      Aggregator.all.should_not be_empty
      Aggregator.each do |agg|
        agg.should be_a(Class)
      end
    end

    it "should allow specific tuple computations" do
      Aggregator.sum{ 1.0 * a * sign }.aggregate(input).should == -3.0
    end

    describe "coerce" do

      subject{ Aggregator.coerce(arg) }

      describe "from an Aggregator" do
        let(:arg){ Aggregator.sum{a} }
        it{ should eq(arg) }
      end
    end

  end
end
