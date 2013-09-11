require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "sort" do

      subject{
        Compilable.new(cog).sort(expr)
      }

      let(:ordering){
        Ordering.new([[:a, :asc]])
      }

      let(:expr){
        sort(an_operand, ordering)
      }

      context 'when the cog is not sorted at all' do
        let(:cog){ leaf }

        it_should_behave_like "a compilable"

        it 'should add a Sort' do
          resulting_cog.should be_a(Sort)
          resulting_cog.ordering.should be(ordering)
          resulting_cog.operand.should be(cog)
        end
      end

      context 'when the cog is sorted the exact same way' do
        let(:cog){ Sort.new(leaf, ordering, expr) }

        it_should_behave_like "a compilable"

        it 'should reuse the cog itself' do
          resulting_cog.should be(cog)
        end
      end

      context 'when the cog is sorted in a compatible way' do
        let(:cog){ Sort.new(leaf, Ordering.new([[:a, :asc], [:b, :desc]]), expr) }

        it_should_behave_like "a compilable"

        it 'should reuse the cog itself' do
          resulting_cog.should be(cog)
        end
      end

      context 'when the cog is sorted in a incompatible way' do
        let(:cog){ Sort.new(leaf, Ordering.new([[:a, :desc]]), expr) }

        it_should_behave_like "a compilable"

        it 'should add a Sort' do
          resulting_cog.should be_a(Sort)
          resulting_cog.ordering.should be(ordering)
          resulting_cog.operand.should be(cog)
        end
      end

    end
  end
end
