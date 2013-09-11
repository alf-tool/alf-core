require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "summarize" do

      subject{
        Compilable.new(leaf).summarize(expr)
      }

      let(:by){
        AttrList[:a]
      }

      let(:summarization){
        Summarization[{ max: Aggregator.max{ qty } }]
      }

      let(:expr){
        summarize(an_operand, by, summarization, allbut: allbut)
      }

      shared_examples_for "the expected Summarize" do
        it_should_behave_like "a compilable"

        it 'has a Summarize' do
          resulting_cog.should be_a(Summarize)
        end

        it 'has correct parameters' do
          resulting_cog.by.should eq(by)
          resulting_cog.summarization.should eq(summarization)
          resulting_cog.allbut.should eq(allbut)
        end
      end

      context 'when allbut' do
        let(:allbut){ true }

        it 'has a Summarize::Hash' do
          resulting_cog.should be_a(Summarize::Hash)
        end

        it_should_behave_like "the expected Summarize"

        it 'has correct sub-cog' do
          resulting_cog.operand.should be(leaf)
        end
      end

      context 'when not allbut' do
        let(:allbut){ false }

        it_should_behave_like "a compilable"

        context 'when not already ordered' do

          it 'has a Summarize::Cesure' do
            resulting_cog.should be_a(Summarize::Cesure)
          end

          it_should_behave_like "the expected Summarize"

          it 'has a Sort as sub-cog' do
            resulting_cog.operand.should be_a(Sort)
            resulting_cog.operand.ordering.should eq(Ordering.new([[:a, :asc]]))
          end

          it 'has correct sub-sub-cog' do
            resulting_cog.operand.operand.should be(leaf)
          end
        end

        context 'when already in good direction' do
          let(:leaf){
            Sort.new(Leaf.new([]), Ordering.new([[:a, :asc]]))
          }

          it 'has a Summarize::Cesure' do
            resulting_cog.should be_a(Summarize::Cesure)
          end

          it_should_behave_like "the expected Summarize"

          it 'has the Sort as sub-cog' do
            resulting_cog.operand.should be(leaf)
          end
        end
      end

    end
  end
end
