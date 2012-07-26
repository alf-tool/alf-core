require 'spec_helper'
module Alf
  module Operator::Relational
    describe Union, 'heading' do

      let(:left){
        an_operand.with_heading(:id => Integer, :name => String)
      }
      let(:expected){
        Heading[:id => Integer, :name => String]
      }

      let(:op){
        a_lispy.union(left, right)
      }
      subject{ op.heading }

      context 'when exactly same heading' do
        let(:right){
          an_operand.with_heading(:id => Integer, :name => String)
        }

        it { should eq(expected) }
      end

      context 'with some subtypes' do
        let(:right){
          an_operand.with_heading(:id => Fixnum, :name => String)
        }

        it { should eq(expected) }
      end

    end
  end
end
