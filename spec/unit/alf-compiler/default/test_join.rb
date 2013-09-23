require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "join" do

      subject{
        compiler.call(expr)
      }

      let(:right){
        compact(an_operand)
      }

      let(:expr){
        join(an_operand(leaf), right)
      }

      it_should_behave_like "a traceable compiled"

      it 'is a Join::Hash cog' do
        subject.should be_a(Engine::Join::Hash)
      end

      it 'has the correct left sub-cog' do
        subject.left.should be(leaf)
      end

      it 'has the correct right sub-cog' do
        subject.right.should be_a(Engine::Compact)
      end

    end
  end
end
