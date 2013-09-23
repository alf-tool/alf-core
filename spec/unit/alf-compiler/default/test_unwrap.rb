require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "unwrap" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        unwrap(an_operand(leaf), :a)
      }

      it_should_behave_like "a traceable cog"

      it 'has a Unwrap cog' do
        subject.should be_a(Engine::Unwrap)
      end

      it 'has the correct unwrapping attribute' do
        subject.attribute.should eq(:a)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
