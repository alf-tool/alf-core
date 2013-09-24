require 'compiler_helper'
module Alf
  class Compiler
    describe Default, "frame" do

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
          subject.offset.should eq(10)
          subject.limit.should eq(20)
        end
      end

      context 'when not already sorted' do
        let(:expr){
          frame(an_operand(leaf), ordering, 10, 20)
        }

        it_should_behave_like "the expected Take"
        it_should_behave_like "a compiled based on an added sub Sort"
      end

      context 'when not already sorted (inference possible)' do
        let(:expr){
          op = an_operand(leaf).with_heading(a: String, b: String)
                               .with_keys([:b])
          frame(op, ordering, 10, 20)
        }

        let(:total_ordering){
          Ordering.new([[:a, :asc], [:b, :asc]])
        }

        it_should_behave_like "the expected Take"
        it_should_behave_like "a compiled based on an added sub Sort with total ordering"
      end

      context 'when already sorted' do
        let(:expr){
          frame(sort(an_operand(leaf), subordering), ordering, 10, 20)
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
