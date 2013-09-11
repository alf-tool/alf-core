require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "extend" do

      subject{
        Compilable.new(leaf).extend(expr)
      }

      let(:expr){
        extend(an_operand, computation)
      }

      let(:computation){
        TupleComputation[{ foo: "12" }]
      }

      it_should_behave_like "a compilable"

      it 'has a SetAttr cog' do
        resulting_cog.should be_a(SetAttr)
      end

      it 'has the correct computation' do
        resulting_cog.computation.should be(computation)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
