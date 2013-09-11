require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "generator" do

      subject{
        Compilable.new(leaf).generator(expr)
      }

      let(:expr){
        generator(100, :foo)
      }

      it_should_behave_like "a compilable"

      it 'has a Generator cog' do
        resulting_cog.should be_a(Generator)
      end

      it 'has the correct generator attribute name' do
        resulting_cog.as.should eq(:foo)
      end

      it 'has the correct generator count' do
        resulting_cog.count.should eq(100)
      end

    end
  end
end
