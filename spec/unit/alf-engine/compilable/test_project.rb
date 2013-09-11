require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "project" do

      subject{
        Compilable.new(leaf).project(expr)
      }

      shared_examples_for "a compacted compilation result" do

        it_should_behave_like "a compilable"

        it 'has a Compact cog' do
          resulting_cog.should be_a(Compact)
        end

        it 'has a Clip sub-cog' do
          resulting_cog.operand.should be_a(Clip)
          resulting_cog.operand.attributes.should eq(AttrList[:a])
          resulting_cog.operand.allbut.should be_false
        end

        it 'has the corect sub-sub cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

      context 'when keys not available' do
        let(:expr){
          project(an_operand, [:a])
        }

        it_should_behave_like "a compacted compilation result"
      end

      context 'when keys are available and not preserving' do
        let(:expr){
          project(an_operand.with_keys([:b]), [:a])
        }

        it_should_behave_like "a compacted compilation result"
      end

      context 'when keys are available and preserving' do
        let(:expr){
          project(an_operand.with_keys([:a]), [:a])
        }

        it_should_behave_like "a compilable"

        it 'has a Clip cog' do
          resulting_cog.should be_a(Clip)
          resulting_cog.attributes.should eq(AttrList[:a])
          resulting_cog.allbut.should be_false
        end

        it 'has the correct sub cog' do
          resulting_cog.operand.should be(leaf)
        end
      end

    end
  end
end
