require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "ungroup" do

      subject{
        compiler.call(expr)
      }

      let(:expr){
        ungroup(an_operand(leaf), :a)
      }

      it_should_behave_like "a traceable compiled"

      it 'has a Ungroup cog' do
        subject.should be_a(Engine::Ungroup)
      end

      it 'has the correct ungrouping attribute' do
        subject.attribute.should eq(:a)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
