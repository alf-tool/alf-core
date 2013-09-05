require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "defaults" do

      subject{
        Compilable.new(leaf).defaults(expr)
      }

      context "when non strict" do
        let(:expr){
          defaults(an_operand, b: 1)
        }

        it_should_behave_like "a compilable"

        it 'has a Defaults cog' do
          resulting_cog.should be_a(Defaults)
        end

        it 'has the correct defaults' do
          resulting_cog.defaults.to_hash.should eq(b: 1)
        end

        it 'has the correct sub-cog' do
          resulting_cog.operand.should be(leaf)
        end

        it 'has correct traceability on cog' do
          subject.expr.should be(expr)
        end
      end

      context "when strict" do
        let(:expr){
          defaults(an_operand, {b: 1}, strict: true)
        }

        it_should_behave_like "a compilable"

        it 'has a Clip cog' do
          resulting_cog.should be_a(Clip)
        end

        it 'has a Defaults sub-cog with correct defaults' do
          resulting_cog.operand.should be_a(Defaults)
          resulting_cog.operand.defaults.to_hash.should eq(b: 1)
        end

        it 'has the correct sub-sub-cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

    end
  end
end
