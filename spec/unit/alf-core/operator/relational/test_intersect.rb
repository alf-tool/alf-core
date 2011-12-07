require 'spec_helper'
module Alf
  module Operator::Relational
    describe Intersect do
        
      let(:operator_class){ Intersect }
      it_should_behave_like("An operator class")
        
      let(:left) {[
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S3', :city => 'Paris'}
      ]}
        
      let(:right) {[
        {:sid => 'S2', :city => 'Paris'},
        {:sid => 'S1', :city => 'London'},
      ]}
        
      let(:disjoint) {[
        {:sid => 'S4', :city => 'Oslo'},
        {:sid => 'S5', :city => 'Bruxelles'},
      ]}
  
      let(:operator){ Intersect.run([]) }
      subject{ operator.to_a }
  
      describe "when applied on the same operand twice" do
        before{ operator.pipe [left, left] }
        it { should == left }
      end
      
      describe "when applied on operands sharing tuples" do
        before{ operator.pipe [left, right] }
        let(:expected) {[
          {:sid => 'S1', :city => 'London'},
          {:sid => 'S2', :city => 'Paris'},
        ]}
        it { should == expected }
      end
    
      describe "when applied on disjoint operands" do
        before{ operator.pipe [left, disjoint] }
        it { should be_empty }
      end
      
      describe "when factored with Lispy" do
        let(:operator){ Lispy.intersect(left, right) }
        let(:expected) {[
          {:sid => 'S1', :city => 'London'},
          {:sid => 'S2', :city => 'Paris'},
        ]}
        it { should == expected }
      end
  
    end 
  end
end