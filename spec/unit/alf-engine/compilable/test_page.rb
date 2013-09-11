require 'compiler_helper'
module Alf
  module Engine
    describe Compilable, "page" do

      subject{
        Compilable.new(leaf).page(expr)
      }

      let(:ordering){
        Ordering.new([[:name, :asc]])
      }

      context 'when positive page' do
        let(:expr){
          page(an_operand, ordering, 3, page_size: 20)
        }

        it_should_behave_like "a compilable"

        it 'has a Take cog' do
          resulting_cog.should be_a(Take)
        end

        it 'has the correct take attributes' do
          resulting_cog.offset.should eq(40)
          resulting_cog.limit.should eq(20)
        end

        it 'has a Sort correct sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should eq(ordering)
        end
      end

      context 'when a negative page' do
        let(:expr){
          page(an_operand, ordering, -3, page_size: 20)
        }

        it_should_behave_like "a compilable"

        it 'has a Take cog' do
          resulting_cog.should be_a(Take)
        end

        it 'has the correct take attributes' do
          resulting_cog.offset.should eq(40)
          resulting_cog.limit.should eq(20)
        end

        it 'has a Sort correct sub-cog' do
          resulting_cog.operand.should be_a(Sort)
          resulting_cog.operand.ordering.should eq(ordering.reverse)
        end
      end

      context 'when already sorted' do
        let(:expr){
          page(an_operand, ordering, 3, page_size: 20)
        }

        let(:leaf){
          Sort.new(Leaf.new([]), ordering)
        }

        it_should_behave_like "a compilable"

        it 'has a Take cog' do
          resulting_cog.should be_a(Take)
        end

        it 'has the correct take attributes' do
          resulting_cog.offset.should eq(40)
          resulting_cog.limit.should eq(20)
        end

        it 'has the Sort as sub-cog' do
          resulting_cog.operand.should be(leaf)
        end
      end

    end
  end
end
