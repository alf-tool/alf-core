require 'spec_helper'
module Alf
  module Operator::Relational
    describe Join, 'heading' do

      let(:left){
        operand_with_heading(:id => Integer, :name => String)
      }

      let(:op){ 
        a_lispy.intersect(left, right)
      }
      subject{ op.heading }

      context 'when disjoint headings' do
        let(:right){
          operand_with_heading(:foo => String)
        }
        let(:expected){
          Heading[:id => Integer, :name => String, :foo => String]
        }

        it { should eq(expected) }
      end

      context 'when non-disjoint headings' do
        let(:right){
          operand_with_heading(:id => Fixnum, :foo => String)
        }
        let(:expected){
          Heading[:id => Integer, :name => String, :foo => String]
        }

        it { should eq(expected) }
      end

    end
  end
end
