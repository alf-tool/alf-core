require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "sort" do

      subject{
        Default.new.call(expr)
      }

      let(:ordering){
        Ordering.new([[:a, :asc]])
      }

      context 'when the cog is not sorted at all' do
        let(:expr){
          sort(an_operand(leaf), ordering)
        }

        it_should_behave_like "a traceable cog"

        it 'should add a Sort' do
          subject.should be_a(Engine::Sort)
          subject.ordering.should be(ordering)
          subject.operand.should be(leaf)
        end
      end

      context 'when the cog is already sorted' do
        let(:expr){
          sort(sort(an_operand(leaf), subordering), ordering)
        }

        context 'in exact same way' do
          let(:subordering){
            Ordering.new([[:a, :asc]])
          }

          it_should_behave_like "a traceable cog"

          it 'should reuse the cog itself' do
            subject.should be_a(Engine::Sort)
            subject.operand.should be(leaf)
            subject.ordering.should be(subordering)
          end
        end

        context 'in a compatible way' do
          let(:subordering){
            Ordering.new([[:a, :asc], [:b, :desc]])
          }

          it_should_behave_like "a traceable cog"

          it 'should reuse the cog itself' do
            subject.should be_a(Engine::Sort)
            subject.operand.should be(leaf)
            subject.ordering.should be(subordering)
          end
        end

        context 'in a incompatible way' do
          let(:subordering){
            Ordering.new([[:a, :desc]])
          }

          it_should_behave_like "a traceable cog"

          it 'should add a Sort' do
            subject.should be_a(Engine::Sort)
            subject.ordering.should be(ordering)
            subject.operand.should be_a(Engine::Sort)
            subject.operand.ordering.should be(subordering)
          end
        end
      end

    end
  end
end
