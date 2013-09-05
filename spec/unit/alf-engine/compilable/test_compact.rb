require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "compact" do

      subject{
        Compilable.new(leaf).compact(expr)
      }

      let(:expr){
        compact(an_operand)
      }

      it_should_behave_like "a compilable"

      it 'has a Compact cog' do
        resulting_cog.should be_a(Compact)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
