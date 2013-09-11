require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "quota" do

      subject{
        Compilable.new(leaf).quota(expr)
      }

      let(:expr){
        quota(an_operand, [:a], ordering, summarization)
      }

      let(:summarization){
        Summarization[{ max: Aggregator.max{ qty } }]
      }

      let(:ordering){
        Ordering.new([[:b, :asc]])
      }

      shared_examples_for "the expected Quota::Cesure" do
        it_should_behave_like "a compilable"

        it 'has a Quota::Cesure cog' do
          resulting_cog.should be_a(Quota::Cesure)
        end

        it 'has the correct parameters' do
          resulting_cog.by.should eq(AttrList[:a])
          resulting_cog.summarization.should be(summarization)
        end
      end

      context 'when not sorted' do
        it_should_behave_like "the expected Quota::Cesure"

        it 'has a Sort as sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should eq(Ordering.new([[:a, :asc], [:b, :asc]]))
        end

        it 'has the leaf has sub-sub cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

      context 'when already sorted' do
        let(:leaf){
          Sort.new(Leaf.new([]), Ordering.new([[:a, :asc], [:b, :asc]]))
        }

        it_should_behave_like "the expected Quota::Cesure"

        it 'has the Sort as sub-cog' do
          resulting_cog.operand.should be(leaf)
        end
      end

      context 'when sorted on incompatible direction' do
        let(:leaf){
          Sort.new(Leaf.new([]), Ordering.new([[:a, :desc], [:b, :asc]]))
        }

        it_should_behave_like "the expected Quota::Cesure"

        it 'has a Sort as sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should eq(Ordering.new([[:a, :asc], [:b, :asc]]))
        end

        it 'has the leaf has sub-sub cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

    end
  end
end
