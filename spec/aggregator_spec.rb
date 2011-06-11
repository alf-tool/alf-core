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
      Aggregator::Count.new(:a).aggregate(input).should == 4
    end

    it "should behave correctly on sum" do
      Aggregator::Sum.new(:a).aggregate(input).should == 7
    end

    it "should behave correctly on avg" do
      Aggregator::Avg.new(:a).aggregate(input).should == 7.0 / 4.0
    end

    it "should behave correctly on min" do
      Aggregator::Min.new(:a).aggregate(input).should == 1
    end

    it "should behave correctly on min" do
      Aggregator::Max.new(:a).aggregate(input).should == 3
    end

    it "should allow specific tuple computations" do
      Aggregator::Sum.new{ 1.0 * a * sign }.aggregate(input).should == -3.0
    end

  end
end
