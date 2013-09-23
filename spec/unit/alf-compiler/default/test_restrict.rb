require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "restrict" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        restrict(an_operand(leaf), predicate)
      }

      let(:predicate){
        Predicate.native(->{ true })
      }

      it_should_behave_like "a traceable cog"

      it 'has a Filter cog' do
        subject.should be_a(Engine::Filter)
      end

      it 'has the correct predicate' do
        subject.predicate.should be(predicate)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
