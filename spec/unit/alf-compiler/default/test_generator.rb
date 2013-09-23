require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "generator" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        generator(100, :foo)
      }

      it_should_behave_like "a traceable cog"

      it 'is a Generator cog' do
        subject.should be_a(Engine::Generator)
      end

      it 'has the correct generator attribute name' do
        subject.as.should eq(:foo)
      end

      it 'has the correct generator count' do
        subject.count.should eq(100)
      end

    end
  end
end
