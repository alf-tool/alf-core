require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "extend" do

      subject{
        compiler.call(expr)
      }

      let(:expr){
        extend(an_operand(leaf), computation)
      }

      let(:computation){
        TupleComputation[{ foo: "12" }]
      }

      it_should_behave_like "a traceable compiled"

      it 'has a SetAttr cog' do
        subject.should be_a(Engine::SetAttr)
      end

      it 'has the correct computation' do
        subject.computation.should be(computation)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
