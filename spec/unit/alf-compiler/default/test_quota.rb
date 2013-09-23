require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "quota" do

      subject{
        Default.new.call(expr)
      }

      let(:summarization){
        Summarization[{ max: Aggregator.max{ qty } }]
      }

      let(:ordering){
        Ordering.new([[:b, :asc]])
      }

      shared_examples_for "the expected Quota::Cesure" do
        it_should_behave_like "a traceable cog"

        it 'has a Quota::Cesure cog' do
          subject.should be_a(Engine::Quota::Cesure)
        end

        it 'has the correct parameters' do
          subject.by.should eq(AttrList[:a])
          subject.summarization.should be(summarization)
        end
      end

      context 'when not sorted' do
        let(:expr){
          quota(an_operand(leaf), [:a], ordering, summarization)
        }

        it_should_behave_like "the expected Quota::Cesure"

        it 'has a Sort as sub-cog' do
          subject.operand.should be_a(Engine::Sort)
          subject.operand.ordering.should eq(Ordering.new([[:a, :asc], [:b, :asc]]))
        end

        it 'has the leaf has sub-sub cog' do
          subject.operand.operand.should be(leaf)
        end
      end

      context 'when already sorted' do
        let(:expr){
          quota(sort(an_operand(leaf), subordering), [:a], ordering, summarization)
        }

        context 'in a compatible way' do
          let(:subordering){
            Ordering.new([[:a, :asc], [:b, :asc]])
          }

          it_should_behave_like "the expected Quota::Cesure"
          it_should_behave_like "a cog reusing a sub Sort"
        end

        context 'in an incompatible way' do
          let(:subordering){
            Ordering.new([[:a, :desc], [:b, :asc]])
          }

          it_should_behave_like "the expected Quota::Cesure"

          it 'has a Sort as sub-cog' do
            subject.operand.should be_a(Engine::Sort)
            subject.operand.ordering.should eq(Ordering.new([[:a, :asc], [:b, :asc]]))
          end

          it 'has a Sort as sub-sub-cog' do
            subject.operand.operand.should be_a(Engine::Sort)
            subject.operand.operand.ordering.should be(subordering)
          end

          it 'has the leaf has sub-sub-sub cog' do
            subject.operand.operand.operand.should be(leaf)
          end
        end

      end

    end
  end
end
