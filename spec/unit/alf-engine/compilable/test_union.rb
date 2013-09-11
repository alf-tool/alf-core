require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "union" do

      subject{
        Compilable.new(leaf).union(expr)
      }

      let(:right){
        clip(an_operand, [:a])
      }

      let(:expr){
        union(an_operand, right)
      }

      it_should_behave_like "a compilable"

      it 'has a Compact cog' do
        resulting_cog.should be_a(Compact)
      end

      it 'has a Concat sub-cog' do
        resulting_cog.operand.should be_a(Concat)
      end

      it 'has the correct sub-sub-cogs' do
        ops = resulting_cog.operand.operands
        ops.first.should be(leaf)
        ops.last.should be_a(Clip)
      end

    end
  end
end
