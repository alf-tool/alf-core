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

    it "should allow specific tuple computations" do
      Aggregator.sum{ 1.0 * a * sign }.aggregate(input).should == -3.0
    end

    describe "coerce" do
     
      subject{ Aggregator.coerce(arg) }
      
      describe "from an Aggregator" do
        let(:arg){ Aggregator.sum{a} }
        it{ should eq(arg) }
      end
      
      describe "from a String" do
        let(:arg){ "sum{a}" }

        it { 
          should be_a(Aggregator::Sum) 
        }

        it 'should have source code' do
          subject.has_source_code!.should eq("sum{a}")
        end

        specify{ 
          subject.aggregate(input).should eql(7) 
        }

      end
      
    end

    it 'should implement optimistic equality based on source code' do
      ag1 = Aggregator.coerce("sum{ qty }")
      ag2 = Aggregator.coerce("sum{ qty }")
      ag1.should eq(ag2)
    end

  end
end
