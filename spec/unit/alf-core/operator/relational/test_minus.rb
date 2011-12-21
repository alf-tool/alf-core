require 'spec_helper'
module Alf
  module Operator::Relational
    describe Minus do

      let(:operator_class){ Minus }
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

      let(:operator){ Lispy.minus(*args) }
      subject{ operator.to_a }

      context "when applied on the same operand twice" do
        let(:args){ [left, left] }
        it { should be_empty }
      end

      context "when applied on operands sharing tuples" do
        let(:args){ [left, right] }
        let(:expected) {[
          {:sid => 'S3', :city => 'Paris'}
        ]}
        it { should eq(expected) }
      end

      context "when applied on disjoint operands" do
        let(:args){ [left, disjoint] }
        it { should eq(left) }
      end

      context "when factored with Lispy" do
        let(:operator){ Lispy.minus(left, right) }
        let(:expected) {[
          {:sid => 'S3', :city => 'Paris'}
        ]}
        it { should eq(expected) }
      end

    end
  end
end
