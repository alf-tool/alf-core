require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "matching" do

      subject{
        compiler.call(expr)
      }

      let(:right){
        compact(an_operand(leaf))
      }

      let(:expr){
        matching(an_operand(leaf), right)
      }

      it_should_behave_like "a traceable compiled"

      it 'has a Join::Hash cog' do
        subject.should be_a(Engine::Semi::Hash)
      end

      it 'has the correct left sub-cog' do
        subject.left.should be(leaf)
      end

      it 'has the correct right sub-cog' do
        subject.right.should be_a(Engine::Compact)
      end

      it 'has the correct predicate' do
        subject.predicate.should be_true
      end

    end
  end
end
