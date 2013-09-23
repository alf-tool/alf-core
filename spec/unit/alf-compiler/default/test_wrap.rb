require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "wrap" do

      subject{
        compiler.call(expr)
      }

      let(:expr){
        wrap(an_operand(leaf), [:foo, :bar], :baz, allbut: true)
      }

      it_should_behave_like "a traceable compiled"

      it 'has a Wrap cog' do
        subject.should be_a(Engine::Wrap)
      end

      it 'has the correct wrapping' do
        subject.attributes.should eq(AttrList[:foo, :bar])
      end

      it 'has the correct as' do
        subject.as.should eq(:baz)
      end

      it 'has the correct allbut' do
        subject.allbut.should be_true
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
