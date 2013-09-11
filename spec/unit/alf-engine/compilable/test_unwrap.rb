require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "unwrap" do

      subject{
        Compilable.new(leaf).unwrap(expr)
      }

      let(:expr){
        unwrap(an_operand, :a)
      }

      it_should_behave_like "a compilable"

      it 'has a Unwrap cog' do
        resulting_cog.should be_a(Unwrap)
      end

      it 'has the correct unwrapping attribute' do
        resulting_cog.attribute.should eq(:a)
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
