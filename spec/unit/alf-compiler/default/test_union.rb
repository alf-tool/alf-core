require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "union" do

      subject{
        Default.new.call(expr)
      }

      let(:right){
        clip(an_operand(leaf), [:a])
      }

      let(:expr){
        union(an_operand(leaf), right)
      }

      it_should_behave_like "a traceable cog"

      it 'has a Compact cog' do
        subject.should be_a(Engine::Compact)
      end

      it 'has a Concat sub-cog' do
        subject.operand.should be_a(Engine::Concat)
      end

      it 'has the correct sub-sub-cogs' do
        ops = subject.operand.operands
        ops.first.should be(leaf)
        ops.last.should be_a(Engine::Clip)
      end

    end
  end
end
