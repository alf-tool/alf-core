require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "restrict" do

      subject{
        Compilable.new(leaf).restrict(expr)
      }

      let(:expr){
        restrict(an_operand, predicate)
      }

      let(:predicate){
        Predicate.native(->{ true })
      }

      it_should_behave_like "a compilable"

      it 'has a Filter cog' do
        resulting_cog.should be_a(Filter)
      end

      it 'has the correct predicate' do
        resulting_cog.predicate.should be(predicate)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
