require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "autonum" do

      subject{
        compiler.call(expr)
      }

      let(:expr){
        autonum(an_operand(leaf), :foo)
      }

      it_should_behave_like "a traceable compiled"

      it 'is an Autonum cog' do
        subject.should be_a(Engine::Autonum)
      end

      it 'has the correct autonum attribute name' do
        subject.as.should eq(:foo)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
