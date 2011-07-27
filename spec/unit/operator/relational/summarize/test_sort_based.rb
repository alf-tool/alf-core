require 'spec_helper'
module Alf
  module Operator::Relational
    describe Summarize::SortBased do
        
      let(:input) {[
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 2},
        {:a => "via_reader", :time => 4},
        {:a => "via_reader", :time => 2},
      ]}
  
      let(:expected) {[
        {:a => "via_method", :time_sum => 4, :time_max => 2},
        {:a => "via_reader", :time_sum => 6, :time_max => 4},
      ]}
  
      let(:aggs){Tools::Summarization.new(
        :time_sum => Aggregator.sum(:time),
        :time_max => Aggregator.max(:time)
      )} 
      let(:operator){ Summarize::SortBased.new(by_key, allbut, aggs) }
  
      before{ operator.pipe(input) }
      subject{ operator.to_a.sort{|t1,t2| t1[:a] <=> t2[:a]} }
  
      describe "when allbut is not set" do
        let(:by_key){ Tools::ProjectionKey.new([:a]) }
        let(:allbut){ false }
        it { should == expected }
      end
  
      describe "when allbut is set" do
        let(:by_key){ Tools::ProjectionKey.new([:time]) }
        let(:allbut){ true }
        it { should == expected }
      end
  
    end 
  end
end