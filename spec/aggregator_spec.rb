require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Aggregator do

    let(:input){[
      {:a => 1, :sign => -1},
      {:a => 2, :sign => 1 },
      {:a => 3, :sign => -1},
      {:a => 1, :sign => -1},
    ]}

    it "should behave correctly on count" do
      Aggregator.count(:a).aggregate(input).should == 4
    end

    it "should behave correctly on sum" do
      Aggregator.sum(:a).aggregate(input).should == 7
    end

    it "should behave correctly on avg" do
      Aggregator.avg(:a).aggregate(input).should == 7.0 / 4.0
    end

    it "should behave correctly on min" do
      Aggregator.min(:a).aggregate(input).should == 1
    end

    it "should behave correctly on min" do
      Aggregator.max(:a).aggregate(input).should == 3
    end

    it "should allow specific tuple computations" do
      Aggregator.sum{ 1.0 * a * sign }.aggregate(input).should == -3.0
    end

  end
end
