require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "rename" do

      subject{
        Compilable.new(leaf).rename(expr)
      }

      let(:expr){
        rename(an_operand, a: :b)
      }

      it_should_behave_like "a compilable"

      it 'has a Rename cog' do
        resulting_cog.should be_a(Rename)
      end

      it 'has the correct rename attributes' do
        resulting_cog.renaming.should eq(Renaming[a: :b])
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
