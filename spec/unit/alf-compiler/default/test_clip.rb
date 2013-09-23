require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "clip" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        clip(an_operand(leaf), [:a])
      }

      it_should_behave_like "a traceable cog"

      it 'has a Clip cog' do
        subject.should be_a(Engine::Clip)
      end

      it 'has the correct clipping attributes' do
        subject.attributes.should eq(AttrList[:a])
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
