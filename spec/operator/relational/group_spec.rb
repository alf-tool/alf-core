require 'spec_helper'
module Alf
  module Operator::Relational
    describe Group do
        
      let(:operator_class){ Group }
      it_should_behave_like("An operator class")
        
      let(:input) {[
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
      ]}
  
      let(:expected) {[
        {:a => "via_method", :as => [{:time => 1, :b => "b"}, {:time => 2, :b => "b"}]},
        {:a => "via_reader", :as => [{:time => 3, :b => "b"}]},
      ]}
  
      subject{ operator.to_a.sort{|k1,k2| k1[:a] <=> k2[:a]} }
  
      describe "without --allbut" do
  
        describe "when factored with commandline args" do
          let(:operator){ Group.run(["--", "time", "b", "as"]) }
          before{ operator.pipe(input) }
          it { should == expected }
        end
    
        describe "when factored with Lispy" do
          let(:operator){ Lispy.group(input, [:time, :b], :as) }
          it { should == expected }
        end
        
      end
  
      describe "with --allbut" do
          
        describe "when factored with commandline args" do
          let(:operator){ Group.run(["--","a", "as"]) }
          before{ operator.allbut = true; operator.pipe(input) }
          it { should == expected }
        end
    
        describe "when factored with Lispy" do
          let(:operator){ Lispy.group(input, [:a], :as, true) }
          it { should == expected }
        end
        
      end
  
    end 
  end
end