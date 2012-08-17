require 'spec_helper'
module Alf
  module Algebra
    describe Join, 'heading' do

      let(:left){
        an_operand.with_heading(:id => Integer, :name => String)
      }

      let(:op){ 
        a_lispy.intersect(left, right)
      }
      subject{ op.heading }

      context 'when disjoint headings' do
        let(:right){
          an_operand.with_heading(:foo => String)
        }
        let(:expected){
          Heading[:id => Integer, :name => String, :foo => String]
        }

        it { should eq(expected) }
      end

      context 'when non-disjoint headings' do
        let(:right){
          an_operand.with_heading(:id => Fixnum, :foo => String)
        }
        let(:expected){
          Heading[:id => Integer, :name => String, :foo => String]
        }

        it { should eq(expected) }
      end

    end
  end
end
