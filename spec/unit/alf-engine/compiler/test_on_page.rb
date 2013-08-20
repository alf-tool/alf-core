require 'spec_helper'
module Alf
  module Engine
    describe Compiler, 'test_on_page' do

      subject{ Compiler.new.call(expr) }

      shared_examples_for "a traceable take" do
        it_should_behave_like "a traceable cog"

        it {
          should be_a(Engine::Take)
        }
      end

      context 'when keys are known and a positive index' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:expr){
          a_lispy.page(operand, [], 3, page_size: 8)
        }

        it_should_behave_like "a traceable take"

        it 'should have correct offset' do
          subject.offset.should eq(16)
        end

        it 'should have correct limit' do
          subject.limit.should eq(8)
        end

        it 'should have a sort as child' do
          subject.operand.should be_a(Engine::Sort)
          subject.operand.ordering.should eq(Ordering.new([[:id, :asc]]))
        end

        it 'should have a leaf as child.child' do
          subject.operand.operand.should be_a(Leaf)
        end
      end

      context 'when keys are known and a page 1' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:expr){
          a_lispy.page(operand, [], 1)
        }

        it_should_behave_like "a traceable take"

        it 'should have offset 0' do
          subject.offset.should eq(0)
        end
      end

      context 'when keys are known and a negative index' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:expr){
          a_lispy.page(operand, [], -3, page_size: 8)
        }

        it_should_behave_like "a traceable take"

        it 'should have correct offset' do
          subject.offset.should eq(16)
        end

        it 'should have correct limit' do
          subject.limit.should eq(8)
        end

        it 'should have a sort with inverse ordering as child' do
          subject.operand.should be_a(Engine::Sort)
          subject.operand.ordering.should eq(Ordering.new([[:id, :desc]]))
        end

        it 'should have a leaf as child.child' do
          subject.operand.operand.should be_a(Leaf)
        end
      end

      context 'when keys are known and a page -1' do
        let(:operand){
          an_operand.with_heading(id: Fixnum, name: String).with_keys([:id])
        }
        let(:expr){
          a_lispy.page(operand, [], -1)
        }

        it_should_behave_like "a traceable take"

        it 'should have offset 0' do
          subject.offset.should eq(0)
        end
      end

      context 'when keys and heading are not supported' do
        let(:operand){
          an_operand
        }
        let(:expr){
          a_lispy.page(operand, [[:id, :asc]], 3, page_size: 8)
        }

        it_should_behave_like "a traceable take"

        it 'should have correct offset' do
          subject.offset.should eq(16)
        end

        it 'should have correct limit' do
          subject.limit.should eq(8)
        end

        it 'should have a sort as child and stick to initial ordering' do
          subject.operand.should be_a(Engine::Sort)
          subject.operand.ordering.should eq(Ordering.new([[:id, :asc]]))
        end
      end

    end
  end
end
