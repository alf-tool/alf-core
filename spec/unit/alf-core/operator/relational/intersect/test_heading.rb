require 'spec_helper'
module Alf
  module Operator::Relational
    describe Intersect, 'heading' do

      let(:left){
        operand_with_heading(:id => Integer, :name => String)
      }
      let(:expected){
        Heading[:id => Integer, :name => String]
      }

      subject{ op.heading }

      context 'when exactly same heading' do
        let(:right){
          operand_with_heading(:id => Integer, :name => String)
        }
        let(:op){ 
          a_lispy.intersect(left, right)
        }

        it { should eq(expected) }
      end

      context 'with some subtypes' do
        let(:right){
          operand_with_heading(:id => Fixnum, :name => String)
        }
        let(:op){ 
          a_lispy.intersect(left, right)
        }

        it { should eq(expected) }
      end

    end
  end
end
