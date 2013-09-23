require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "rename" do

      subject{
        Default.new.call(expr)
      }

      let(:expr){
        rename(an_operand(leaf), a: :b)
      }

      it_should_behave_like "a traceable cog"

      it 'has a Rename cog' do
        subject.should be_a(Engine::Rename)
      end

      it 'has the correct rename attributes' do
        subject.renaming.should eq(Renaming[a: :b])
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
