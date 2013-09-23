require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "type_safe" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        type_safe(an_operand(leaf), a: String)
      }

      it_should_behave_like "a traceable cog"

      it 'has a TypeSafe cog' do
        subject.should be_a(Engine::TypeSafe)
      end

      it 'has the correct type safe heading' do
        subject.checker.heading.should eq(Heading[a: String])
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
