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

      let(:operator){ Intersect.run(args) }
      subject{ operator.to_a }

      context "with same operand twice" do
        let(:args){ [left, left] }
        it { should eq(left) }
      end

      context "on operands sharing tuples" do
        let(:args){ [left, right] }
        let(:expected) {[
          {:sid => 'S1', :city => 'London'},
          {:sid => 'S2', :city => 'Paris'},
        ]}
        it { should eq(expected) }
      end

      context "on disjoint operands" do
        let(:args){ [left, disjoint] }
        it { should be_empty }
      end

      context "with Lispy" do
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
