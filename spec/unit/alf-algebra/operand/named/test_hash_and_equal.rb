require 'spec_helper'
module Alf
  module Algebra
    module Operand
      describe Named, "hash and ==" do

        let(:op1){
          Named.new(:foo)
        }

        context '==' do

          it 'recognizes same operands' do
            op1.should eq(op1)
            op1.should eq(Named.new(:foo))
          end

          it 'distinguises other operands' do
            op1.should_not eq(nil)
            op1.should_not eq(Named.new(:foo, :bar))
          end
        end

        context 'hash' do

          it 'it the same on same operands' do
            op1.hash.should eq(Named.new(:foo).hash)
          end
        end

        context 'using named operands as hash keys' do

          let(:h){
            { op1 => 1,
              Named.new(:bar) => 2,
              Named.new(:foo, :bar) => 3 }
          }

          it 'should lead to expected hash' do
            h.size.should eq(3)
          end

          it 'should behave as expected' do
            h[op1].should eq(1)
            h[Named.new(:foo)].should eq(1)
            h[Named.new(:foo, :bar)].should eq(3)
          end
        end

      end
    end
  end
end
