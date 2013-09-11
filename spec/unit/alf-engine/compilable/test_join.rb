require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "join" do

      subject{
        Compilable.new(leaf).join(expr)
      }

      let(:right){
        compact(an_operand)
      }

      let(:expr){
        join(an_operand, right)
      }

      it_should_behave_like "a compilable"

      it 'has a Join::Hash cog' do
        resulting_cog.should be_a(Join::Hash)
      end

      it 'has the correct left sub-cog' do
        resulting_cog.left.should be(leaf)
      end

      it 'has the correct right sub-cog' do
        resulting_cog.right.should be_a(Compact)
      end

    end
  end
end
