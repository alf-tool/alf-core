require 'spec_helper'
module Alf
  describe Ordering, "sorter" do

    subject{ ordering.sorter }

    context 'on an ordering with single names' do
      let(:ordering){ Ordering.coerce([[:a, :desc]]) }

      let(:tuples){
        [{a: 2},
         {a: 7},
         {a: 1}]
      }

      let(:expected){
        [{a: 7},
         {a: 2},
         {a: 1}]
      }

      it 'should sort correctly' do
        tuples.sort(&subject).should eq(expected)
      end
    end

    context 'on an ordering with hierarchical names' do
      let(:ordering){ Ordering.coerce([[:a, :asc], [[:b, :x], :desc]]) }

      let(:tuples){
        [{a: 2, b: {x: 1}},
         {a: 7, b: {x: 1}},
         {a: 2, b: {x: 2}}]
      }

      let(:expected){
        [{a: 2, b: {x: 2}},
         {a: 2, b: {x: 1}},
         {a: 7, b: {x: 1}}]
      }

      it 'should sort correctly' do
        tuples.sort(&subject).should eq(expected)
      end
    end

    context 'when RVA attributes are involved' do
      let(:ordering){ Ordering.coerce([[:a, :asc], [[:b, :x], :desc]]) }

      let(:tuples){
        [{a: 2, b: [{x: 1}]},
         {a: 7, b: [{x: 1}]},
         {a: 2, b: [{x: 2}]}]
      }

      let(:expected){
        [{a: 2, b: [{x: 1}]},
         {a: 2, b: [{x: 2}]},
         {a: 7, b: [{x: 1}]}]
      }

      it 'should sort correctly' do
        pending{
          tuples.sort(&subject).should eq(expected)
        }
      end
    end

  end # Ordering
end # Alf
