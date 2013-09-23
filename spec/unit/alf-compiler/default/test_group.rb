require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "group" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        group(an_operand(leaf), [:foo, :bar], :baz, allbut: true)
      }

      it_should_behave_like "a traceable cog"

      it 'has a Group cog' do
        subject.should be_a(Engine::Group)
      end

      it 'has the correct grouping' do
        subject.attributes.should eq(AttrList[:foo, :bar])
      end

      it 'has the correct as' do
        subject.as.should eq(:baz)
      end

      it 'has the correct allbut' do
        subject.allbut.should be_true
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
