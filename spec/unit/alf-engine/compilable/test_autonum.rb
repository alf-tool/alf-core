require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "autonum" do

      subject{
        Compilable.new(leaf).autonum(expr)
      }

      let(:expr){
        autonum(an_operand, :foo)
      }

      it_should_behave_like "a compilable"

      it 'has a Autonum cog' do
        resulting_cog.should be_a(Autonum)
      end

      it 'has the correct autonum attribute name' do
        resulting_cog.as.should eq(:foo)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
