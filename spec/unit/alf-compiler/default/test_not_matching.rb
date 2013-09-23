require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "not_matching" do

      subject{
        Default.new.call(expr)
      }

      let(:right){
        compact(an_operand(leaf))
      }

      let(:expr){
        not_matching(an_operand(leaf), right)
      }

      it_should_behave_like "a traceable cog"

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
        subject.predicate.should be_false
      end

    end
  end
end
