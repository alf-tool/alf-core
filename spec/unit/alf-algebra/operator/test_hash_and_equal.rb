require 'spec_helper'
module Alf
  module Algebra
    describe Operator, "hash and ==" do

      let(:foo){
        Operand::Named.new(:foo)
      }

      let(:bar){
        Operand::Named.new(:bar)
      }

      let(:op1){
        a_lispy.restrict(foo, x: 12)
      }

      context '==' do

        it 'recognizes same operands' do
          op1.should eq(op1)
          op1.should eq(a_lispy.restrict(foo, x: 12))
        end

        it 'distinguises other operands' do
          op1.should_not eq(nil)
          op1.should_not eq(a_lispy.restrict(bar, x: 12))
          op1.should_not eq(a_lispy.restrict(foo, x: 13))
        end
      end

      context 'hash' do

        it 'it the same on same operands' do
          op1.hash.should eq(a_lispy.restrict(foo, x: 12).hash)
        end
      end

      context 'using named operands as hash keys' do

        let(:h){
          { op1 => 1,
            a_lispy.restrict(bar, x: 12) => 2 }
        }

        it 'should lead to expected hash' do
          h.size.should eq(2)
        end

        it 'should behave as expected' do
          h[op1].should eq(1)
          h[a_lispy.restrict(bar, x: 12)].should eq(2)
          h[a_lispy.restrict(foo, x: 12)].should eq(1)
        end
      end

    end
  end
end
