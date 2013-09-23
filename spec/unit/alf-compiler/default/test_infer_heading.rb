require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "infer_heading" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        infer_heading(an_operand(leaf))
      }

      it_should_behave_like "a traceable cog"

      it 'has a InferHeading cog' do
        subject.should be_a(Engine::InferHeading)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
