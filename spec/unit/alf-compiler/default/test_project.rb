require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "project" do

      subject{
        compiler.call(expr)
      }

      shared_examples_for "a compacted compilation result" do

        it_should_behave_like "a traceable compiled"

        it 'has a Compact cog' do
          subject.should be_a(Engine::Compact)
        end

        it 'has a Clip sub-cog' do
          subject.operand.should be_a(Engine::Clip)
          subject.operand.attributes.should eq(AttrList[:a])
          subject.operand.allbut.should eq(allbut)
        end

        it 'has the corect sub-sub cog' do
          subject.operand.operand.should be(leaf)
        end
      end

      let(:allbut){ false }

      context 'when keys not available' do
        let(:expr){
          project(an_operand(leaf), [:a])
        }

        it_should_behave_like "a compacted compilation result"
      end

      context 'when keys not available (allbut)' do
        let(:expr){
          project(an_operand(leaf), [:a], allbut: true)
        }
        let(:allbut){ true }

        it_should_behave_like "a compacted compilation result"
      end

      context 'when keys are available and not preserving' do
        let(:expr){
          project(an_operand(leaf).with_keys([:b]), [:a])
        }

        it_should_behave_like "a compacted compilation result"
      end

      context 'when keys are available and preserving' do
        let(:expr){
          project(an_operand(leaf).with_keys([:a]), [:a])
        }

        it_should_behave_like "a traceable cog"

        it 'has a Clip cog' do
          subject.should be_a(Engine::Clip)
          subject.attributes.should eq(AttrList[:a])
          subject.allbut.should be_false
        end

        it 'has the correct sub cog' do
          subject.operand.should be(leaf)
        end
      end

    end
  end
end
