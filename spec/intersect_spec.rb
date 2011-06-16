require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe Intersect do
      
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

    let(:operator){ Intersect.new }
    subject{ operator.to_a }

    describe "when applied on the same operand twice" do
      before{ operator.datasets = [left, left] }
      it { should == left }
    end
    
    describe "when applied on operands sharing tuples" do
      before{ operator.datasets = [left, right] }
      let(:expected) {[
        {:sid => 'S1', :city => 'London'},
        {:sid => 'S2', :city => 'Paris'},
      ]}
      it { should == expected }
    end
  
    describe "when applied on disjoint operands" do
      before{ operator.datasets = [left, disjoint] }
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
