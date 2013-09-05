require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "clip" do

      subject{
        Compilable.new(leaf).clip(expr)
      }

      let(:expr){
        clip(an_operand, [:a])
      }

      it_should_behave_like "a compilable"

      it 'has a Clip cog' do
        resulting_cog.should be_a(Clip)
      end

      it 'has the correct clipping attributes' do
        resulting_cog.attributes.should eq(AttrList[:a])
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
