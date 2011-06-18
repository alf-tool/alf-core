require 'spec_helper'
module Alf
  module Operator::Relational
    describe Unnest do
        
      let(:operator_class){ Unnest }
      it_should_behave_like("An operator class")
        
      let(:input) {[
        {:nested => {:a => "a", :b => "b"}, :c => "c"}
      ]}
  
      let(:expected) {[
        {:a => "a", :b => "b", :c => "c"},
      ]}
  
      subject{ operator.to_a }
  
      describe "when factored with commandline args" do
        let(:operator){ Unnest.run(%w{-- nested}) }
        before{ operator.pipe(input) }
        it { should == expected }
      end
  
      describe "when factored with Lispy" do
        let(:operator){ Lispy.unnest(input, :nested) }
        it { should == expected }
      end
  
    end 
  end
end