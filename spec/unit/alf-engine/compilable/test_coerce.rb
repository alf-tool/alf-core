require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "autonum" do

      subject{
        Compilable.new(leaf).coerce(expr)
      }

      let(:expr){
        coerce(an_operand, a: String)
      }

      it_should_behave_like "a compilable"

      it 'has a Coerce cog' do
        resulting_cog.should be_a(Coerce)
      end

      it 'has the correct coercion heading' do
        resulting_cog.coercions.should eq(Heading[a: String])
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
