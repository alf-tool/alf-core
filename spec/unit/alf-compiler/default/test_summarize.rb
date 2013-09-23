require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "summarize" do

      subject{
        Default.new.call(expr)
      }

      let(:by){
        AttrList[:a]
      }

      let(:summarization){
        Summarization[{ max: Aggregator.max{ qty } }]
      }

      let(:expr){
        summarize(an_operand(leaf), by, summarization, allbut: allbut)
      }

      shared_examples_for "the expected Summarize" do
        it_should_behave_like "a traceable cog"

        it 'has a Summarize' do
          subject.should be_a(Engine::Summarize)
        end

        it 'has correct parameters' do
          subject.by.should eq(by)
          subject.summarization.should eq(summarization)
          subject.allbut.should eq(allbut)
        end
      end

      context 'when allbut' do
        let(:allbut){ true }

        it 'has a Summarize::Hash' do
          subject.should be_a(Engine::Summarize::Hash)
        end

        it_should_behave_like "the expected Summarize"

        it 'has correct sub-cog' do
          subject.operand.should be(leaf)
        end
      end

      context 'when not allbut' do
        let(:allbut){ false }
        let(:ordering){
          Ordering.new([[:a, :asc]])
        }

        context 'when not already ordered' do
          it 'has a Summarize::Cesure' do
            subject.should be_a(Engine::Summarize::Cesure)
          end

          it_should_behave_like "the expected Summarize"
          it_should_behave_like "a cog adding a sub Sort"
        end

        context 'when already in good direction' do
          let(:expr){
            summarize(sort(an_operand(leaf), subordering), by, summarization, allbut: allbut)
          }

          let(:subordering){
            Ordering.new([[:a, :asc]])
          }

          it 'has a Summarize::Cesure' do
            subject.should be_a(Engine::Summarize::Cesure)
          end

          it_should_behave_like "the expected Summarize"
          it_should_behave_like "a cog reusing a sub Sort"
        end
      end

    end
  end
end
