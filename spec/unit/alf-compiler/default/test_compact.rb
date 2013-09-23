require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "compact" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        compact(an_operand(leaf))
      }

      it_should_behave_like "a traceable cog"

      it 'has a Compact cog' do
        subject.should be_a(Engine::Compact)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
