require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "coerce" do

      subject{
        compiler.call(expr)
      }

      let(:expr){
        coerce(an_operand(leaf), a: String)
      }

      it_should_behave_like "a traceable compiled"

      it 'has a Coerce cog' do
        subject.should be_a(Engine::Coerce)
      end

      it 'has the correct coercion heading' do
        subject.coercions.should eq(Heading[a: String])
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
