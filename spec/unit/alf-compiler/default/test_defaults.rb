require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "defaults" do

      subject{
        compiler.call(expr)
      }

      shared_examples_for 'the expected Defaults' do

        it_should_behave_like "a traceable compiled"

        it 'has a Defaults cog' do
          subject.should be_a(Engine::Defaults)
        end

        it 'has the correct defaults' do
          subject.defaults.to_hash.should eq(b: 1)
        end
      end

      context "when non strict" do
        let(:expr){
          defaults(an_operand(leaf), b: 1)
        }

        it_should_behave_like "the expected Defaults"

        it 'has the correct sub-cog' do
          subject.operand.should be(leaf)
        end
      end

      context "when strict" do
        let(:expr){
          defaults(an_operand(leaf), {b: 1}, strict: true)
        }

        it_should_behave_like "the expected Defaults"

        it 'has a Clip sub-sub cog' do
          subject.operand.should be_a(Engine::Clip)
          subject.operand.attributes.should eq(AttrList[:b])
        end
      end

    end
  end
end
