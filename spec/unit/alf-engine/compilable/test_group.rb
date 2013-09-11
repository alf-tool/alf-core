require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "group" do

      subject{
        Compilable.new(leaf).group(expr)
      }

      let(:expr){
        group(an_operand, [:foo, :bar], :baz, allbut: true)
      }

      it_should_behave_like "a compilable"

      it 'has a Group cog' do
        resulting_cog.should be_a(Group)
      end

      it 'has the correct grouping' do
        resulting_cog.attributes.should eq(AttrList[:foo, :bar])
      end

      it 'has the correct as' do
        resulting_cog.as.should eq(:baz)
      end

      it 'has the correct allbut' do
        resulting_cog.allbut.should be_true
      end

      it 'has the correct sub-cog' do
        resulting_cog.operand.should be(leaf)
      end

    end
  end
end
