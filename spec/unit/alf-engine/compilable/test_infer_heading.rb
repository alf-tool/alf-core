require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "infer_heading" do

      subject{
        Compilable.new(leaf).infer_heading(expr)
      }

      let(:expr){
        infer_heading(an_operand)
      }

      it_should_behave_like "a compilable"

      it 'has a InferHeading cog' do
        resulting_cog.should be_a(InferHeading)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
