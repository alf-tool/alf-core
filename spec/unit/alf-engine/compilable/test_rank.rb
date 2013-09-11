require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "rank" do

      subject{
        Compilable.new(leaf).rank(expr)
      }

      let(:expr){
        rank(an_operand, ordering, :foo)
      }

      let(:ordering){
        Ordering.new([[:b, :asc]])
      }

      shared_examples_for "the expected Rank::Cesure" do
        it_should_behave_like "a compilable"

        it 'has a Rank::Cesure cog' do
          resulting_cog.should be_a(Rank::Cesure)
        end

        it 'has the correct parameters' do
          resulting_cog.by.should eq(AttrList[:b])
          resulting_cog.as.should eq(:foo)
        end
      end

      context 'when not sorted' do
        it_should_behave_like "the expected Rank::Cesure"

        it 'has a Sort as sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should eq(ordering)
        end

        it 'has the leaf has sub-sub cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

      context 'when already sorted' do
        let(:leaf){
          Sort.new(Leaf.new([]), ordering)
        }

        it_should_behave_like "the expected Rank::Cesure"

        it 'has the Sort as sub-cog' do
          resulting_cog.operand.should be(leaf)
        end
      end

      context 'when sorted on incompatible direction' do
        let(:leaf){
          Sort.new(Leaf.new([]), Ordering.new([[:b, :desc]]))
        }

        it_should_behave_like "the expected Rank::Cesure"

        it 'has a Sort as sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should eq(ordering)
        end

        it 'has the leaf has sub-sub cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

    end
  end
end
