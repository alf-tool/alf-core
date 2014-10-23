require 'optimizer_helper'
module Alf
  class Optimizer
    describe Restrict, "on_unwrap" do

      let(:operand) { an_operand.with_heading(id: Integer, wrapped: Tuple[x: Integer, y: Integer]) }

      let(:expr)     { restrict(unwrap(operand, :wrapped), predicate) }
      let(:optimized){ Restrict.new.call(expr)                        }
      let(:expected) { Support.to_lispy(expected_rewrite)             }

      subject{ Support.to_lispy(optimized) }

      context 'when the restriction does touch unwrapped attributes' do
        let(:predicate){ Predicate.eq(x: 12) }
        let(:expected_rewrite){ restrict(unwrap(operand, :wrapped), predicate) }

        it{ should eq(expected) }
      end

      context 'when the type is not a Tuple' do
        let(:operand) { an_operand.with_heading(id: Integer, wrapped: Object) }
        let(:predicate){ Predicate.eq(id: 12) }
        let(:expected_rewrite){ restrict(unwrap(operand, :wrapped), predicate) }

        it{ should eq(expected) }
      end

      context 'when the restriction does not touch unwrapped attributes' do
        let(:predicate){ Predicate.eq(id: 12) }
        let(:expected_rewrite){ unwrap(restrict(operand, predicate), :wrapped) }

        it{ should eq(expected) }
      end

    end
  end
end
