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
        {:a => "via_method", :time_sum => 4, :time_max => 2},
        {:a => "via_reader", :time_sum => 6, :time_max => 4},
      ]}
  
      subject{ operator.to_a.sort{|t1,t2| t1[:a] <=> t2[:a]} }
  
      describe "without allbut" do
        
        describe "When factored with commandline args" do
          let(:opts){ ["--by=a"] }
          let(:aggs){ ["time_sum", "sum(:time)", "time_max", "max(:time)"] }
          let(:operator){ Summarize.run(opts + ["--"] +aggs) }
          before{ operator.pipe(input) }
          it { should == expected }
        end
    
        describe "When factored with Lispy" do
          let(:aggs){{:time_sum => Aggregator.sum(:time),
                      :time_max => Aggregator.max(:time)}} 
          let(:operator){ Lispy.summarize(input, [:a], aggs) }
          it { should == expected }
        end

      end
  
      describe "with allbut" do
        
        describe "When factored with commandline args" do
          let(:opts){ ["--by=time", "--allbut"] }
          let(:aggs){ ["time_sum", "sum(:time)", "time_max", "max(:time)"] }
          let(:operator){ Summarize.run(opts + ["--"] + aggs) }
          before{ operator.pipe(input) }
          it { should == expected }
        end
    
        describe "When factored with Lispy" do
          let(:aggs){{:time_sum => Aggregator.sum(:time),
                      :time_max => Aggregator.max(:time)}} 
          let(:operator){ Lispy.summarize(input, [:time], aggs, true) }
          it { should == expected }
        end

      end
  
    end 
  end
end