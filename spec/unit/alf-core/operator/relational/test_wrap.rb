require 'spec_helper'
module Alf
  module Operator::Relational
    describe Wrap do
        
      let(:operator_class){ Wrap }
      it_should_behave_like("An operator class")
        
      let(:input) {[
        {:a => "a", :b => "b", :c => "c"},
      ]}
  
      let(:expected) {[
        {:wraped => {:a => "a", :b => "b"}, :c => "c"}
      ]}
  
      subject{ operator.to_a }
  
      describe "when factored with commandline args" do
        let(:operator){ Wrap.run(["--", "a", "b", "--", "wraped"]) }
        before{ operator.pipe(input) }
        it { should == expected }
      end
  
      describe "when factored with Lispy" do
        let(:operator){ Lispy.wrap(input, [:a, :b], :wraped) }
        it { should == expected }
      end
  
    end 
  end
end