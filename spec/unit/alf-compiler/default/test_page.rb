require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "page" do

      subject{
        compiler.call(expr)
      }

      let(:ordering){
        Ordering.new([[:a, :asc]])
      }

      shared_examples_for "the expected Take" do
        it_should_behave_like "a traceable compiled"

        it 'has a Take cog' do
          subject.should be_a(Engine::Take)
        end

        it 'has the correct take attributes' do
          subject.offset.should eq(40)
          subject.limit.should eq(20)
        end
      end

      context 'when positive page' do
        let(:expr){
          page(an_operand(leaf), ordering, 3, page_size: 20)
        }

        it_should_behave_like "the expected Take"
        it_should_behave_like "a compiled based on an added sub Sort"
      end

      context 'when a negative page' do
        let(:expr){
          page(an_operand(leaf), ordering, -3, page_size: 20)
        }

        it_should_behave_like "the expected Take"
        it_should_behave_like "a compiled based on an added reversed Sort"
      end

      context 'when already sorted' do
        let(:expr){
          page(sort(an_operand(leaf), subordering), ordering, 3, page_size: 20)
        }

        context 'in a compatible way' do
          let(:subordering){
            Ordering.new([[:a, :asc], [:b, :desc]])
          }

          it_should_behave_like "the expected Take"
          it_should_behave_like "a compiled reusing a sub Sort"
        end

        context 'in incompatible way' do
          let(:subordering){
            Ordering.new([[:a, :desc]])
          }

          it_should_behave_like "the expected Take"
          it_should_behave_like "a compiled not reusing a sub Sort"
        end
      end

    end
  end
end
