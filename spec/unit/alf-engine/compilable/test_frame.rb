require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "frame" do

      subject{
        Compilable.new(leaf).frame(expr)
      }

      let(:expr){
        frame(an_operand, ordering, 10, 20)
      }

      let(:ordering){
        Ordering.new([[:name, :asc]])
      }

      shared_examples_for "the expected Take" do
        it_should_behave_like "a compilable"

        it 'has a Take cog' do
          resulting_cog.should be_a(Take)
        end

        it 'has the correct take attributes' do
          resulting_cog.offset.should eq(10)
          resulting_cog.limit.should eq(20)
        end
      end

      context 'when not sorted already sorted' do
        it_should_behave_like "the expected Take"

        it 'has a Sort as sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should be(ordering)
        end

        it 'has leaf as sub-sub cog' do
          resulting_cog.operand.operand.should be(leaf)
        end
      end

      context 'when already sorted' do
        let(:leaf){
          Sort.new(Leaf.new([]), ordering)
        }

        it_should_behave_like "the expected Take"

        it 'has the Sort as sub-cog' do
          resulting_cog.operand.should be(leaf)
        end
      end

    end
  end
end
