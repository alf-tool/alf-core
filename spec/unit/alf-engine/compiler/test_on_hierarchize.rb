require 'spec_helper'
module Alf
  module Engine
    describe Compiler, 'test_on_hierarchize' do

      subject{ Compiler.new.call(expr) }

      context 'the normal case' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, parent: Integer).with_keys([:id])
        }
        let(:expr){
          a_lispy.hierarchize(operand, :id, :parent, :as)
        }

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
      end

    end
  end
end
