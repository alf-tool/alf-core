require File.expand_path('../spec_helper', __FILE__)
module Alf
  describe Minus do
      
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

    let(:operator){ Minus.run([]) }
    subject{ operator.to_a }

    describe "when applied on the same operand twice" do
      before{ operator.datasets = [left, left] }
      it { should be_empty }
    end
    
    describe "when applied on operands sharing tuples" do
      before{ operator.datasets = [left, right] }
      let(:expected) {[
        {:sid => 'S3', :city => 'Paris'}
      ]}
      it { should == expected }
    end
  
    describe "when applied on disjoint operands" do
      before{ operator.datasets = [left, disjoint] }
      it { should == left }
    end
    
    describe "when factored with Lispy" do
      let(:operator){ Lispy.minus(left, right) }
      let(:expected) {[
        {:sid => 'S3', :city => 'Paris'}
      ]}
      it { should == expected }
    end

  end 
end
