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

    it "should behave correctly on max" do
      Aggregator.max(:a).aggregate(input).should == 3
    end

    it "should behave correctly on concat" do
      Aggregator.concat(:a).aggregate(input).should == "1231"
      Aggregator.concat(:a, :between => " ").aggregate(input).should == "1 2 3 1"
      Aggregator.concat(:a, :before => "[", :after => "]").aggregate(input).should == "[1231]"
      Aggregator.concat(:before => "[", :after => "]"){ a }.aggregate(input).should == "[1231]"
    end

    it "should behave correctly on collect" do
      Aggregator.collect(:a).aggregate(input).should == [1, 2, 3, 1]
      Aggregator.collect{ {:a => a, :sign => sign} }.aggregate(input).should == input
    end

    it "should allow specific tuple computations" do
      Aggregator.sum{ 1.0 * a * sign }.aggregate(input).should == -3.0
    end

  end
end
