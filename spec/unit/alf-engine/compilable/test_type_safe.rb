require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "type_safe" do

      subject{
        Compilable.new(leaf).type_safe(expr)
      }

      let(:expr){
        type_safe(an_operand, a: String)
      }

      it_should_behave_like "a compilable"

      it 'has a TypeSafe cog' do
        resulting_cog.should be_a(TypeSafe)
      end

      it 'has the correct type safe heading' do
        resulting_cog.checker.heading.should eq(Heading[a: String])
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
