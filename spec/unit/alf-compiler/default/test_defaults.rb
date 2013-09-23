require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "defaults" do

      subject{
        compiler.call(expr)
      }

      context "when non strict" do
        let(:expr){
          defaults(an_operand(leaf), b: 1)
        }

        it_should_behave_like "a traceable compiled"

        it 'has a Defaults cog' do
          subject.should be_a(Engine::Defaults)
        end

        it 'has the correct defaults' do
          subject.defaults.to_hash.should eq(b: 1)
        end

        it 'has the correct sub-cog' do
          subject.operand.should be(leaf)
        end
      end

      context "when strict" do
        let(:expr){
          defaults(an_operand(leaf), {b: 1}, strict: true)
        }

        it_should_behave_like "a traceable compiled"

        it 'has a Clip cog' do
          subject.should be_a(Engine::Clip)
        end

        it 'has a Defaults sub-cog with correct defaults' do
          subject.operand.should be_a(Engine::Defaults)
          subject.operand.defaults.to_hash.should eq(b: 1)
        end

        it 'has the correct sub-sub-cog' do
          subject.operand.operand.should be(leaf)
        end
      end

    end
  end
end
