require 'spec_helper'
module Alf
  module Operator::Relational
    describe Summarize do

      let(:operator_class){ Summarize }
      it_should_behave_like("An operator class")

      let(:input) {[
        {:a => "via_reader", :time => 2},
        {:a => "via_method", :time => 1},
        {:a => "via_method", :time => 2},
        {:a => "via_reader", :time => 4},
        {:a => "via_method", :time => 1},
      ]}

      let(:expected) {[
        {:a => "via_method", :time_sum => 4, :time_max => 2, :time_avg => 4.0/3},
        {:a => "via_reader", :time_sum => 6, :time_max => 4, :time_avg => 6.0/2},
      ]}

      let(:aggs){{:time_sum => Aggregator.sum{ time },
                  :time_max => Aggregator.max{ time },
                  :time_avg => Aggregator.avg{ time }}} 

      subject{ operator.to_a.sort{|t1,t2| t1[:a] <=> t2[:a]} }

      context "--no-allbut" do
        context "with Lispy" do
          let(:operator){ a_lispy.summarize(input, [:a], aggs) }
          it { should eq(expected) }
        end
      end # --no-allbut

      context "--allbut" do
        context "with Lispy" do
          let(:operator){ a_lispy.summarize(input, [:time], aggs, :allbut => true) }
          it { should eq(expected) }
        end
      end # --allbut

    end 
  end
end
