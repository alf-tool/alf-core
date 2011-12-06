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
      Aggregator.aggregators.should_not be_empty
      Aggregator.each do |agg|
        agg.should be_a(Class)
      end
    end

    it "should behave correctly on stddev" do
      vals = input.collect{|t| t[:a]}
      mean = vals.inject(:+) / vals.size.to_f
      exp  = vals.collect{|v| (v - mean)**2 }.inject(:+) / vals.size.to_f
      exp  = Math.sqrt(exp)
      Aggregator.stddev{a}.aggregate(input).should == exp
    end

    it "should behave correctly on concat" do
      Aggregator.concat{a}.aggregate(input).should == "1231"
      Aggregator.concat(:between => " "){ a }.aggregate(input).should == "1 2 3 1"
      Aggregator.concat(:before => "[", :after => "]"){ a }.aggregate(input).should == "[1231]"
    end

    it "should behave correctly on collect" do
      Aggregator.collect{a}.aggregate(input).should == [1, 2, 3, 1]
      Aggregator.collect{ {:a => a, :sign => sign} }.aggregate(input).should == input
    end

    it "should allow specific tuple computations" do
      Aggregator.sum{ 1.0 * a * sign }.aggregate(input).should == -3.0
    end

    describe Aggregator::Variance do
      let(:values){ [1, 2, 3, 4, 5, 6] }
      let(:stdev){ Aggregator::Variance.new }
      specify{
        memo = values.inject(stdev.least){|memo,val| 
          stdev._happens(memo, val)
        }
        stdev.finalize(memo).should eq(17.5/6.0)
      }
    end

    describe Aggregator::Stddev do
      let(:values){ [2, 4, 4, 4, 5, 5, 7, 9] }
      let(:stdev){ Aggregator::Stddev.new }
      specify{
        memo = values.inject(stdev.least){|memo,val| 
          stdev._happens(memo, val)
        }
        stdev.finalize(memo).should eq(2.0)
      }
    end

    describe "coerce" do
     
      subject{ Aggregator.coerce(arg) }
      
      describe "from an Aggregator" do
        let(:arg){ Aggregator.sum{a} }
        it{ should eq(arg) }
      end
      
      describe "from a String" do
        let(:arg){ "sum{a}" }
        it{ should be_a(Aggregator::Sum) }
        specify{ subject.aggregate(input).should eql(7) }
      end
      
    end

  end
end
