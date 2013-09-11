require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "ungroup" do

      subject{
        Compilable.new(leaf).ungroup(expr)
      }

      let(:expr){
        ungroup(an_operand, :a)
      }

      it_should_behave_like "a compilable"

      it 'has a Ungroup cog' do
        resulting_cog.should be_a(Ungroup)
      end

      it 'has the correct ungrouping attribute' do
        resulting_cog.attribute.should eq(:a)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
