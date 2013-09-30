require 'compiler_helper'
module Alf
  class Compiler
    describe Compiler, 'on_hierarchize' do

      subject{
        compiler.call(expr)
      }

      let(:operand){
        an_operand.with_heading(id: Fixnum, parent: Integer).with_keys([:id])
      }

      let(:expr){
        a_lispy.hierarchize(an_operand(leaf), :id, :parent, :as)
      }

      it_should_behave_like "a traceable compiled"

      it{ should be_a(Engine::Hierarchize) }

      it 'should have correct id list' do
        subject.id.should eq(AttrList[:id])
      end

      it 'should have correct parent list' do
        subject.parent.should eq(AttrList[:parent])
      end

      it 'should have correct children name' do
        subject.children.should eq(:as)
      end

      it 'has the correct sub-cog' do
        subject.operand.should be(leaf)
      end

    end
  end
end
