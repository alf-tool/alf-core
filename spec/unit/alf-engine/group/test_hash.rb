require 'spec_helper'
module Alf
  module Engine
    describe Group::Hash do

      context 'the normal case' do
        let(:operand){[
          {name: "Smith", city: "London"},
          {name: "Jones", city: "Paris"},
          {name: "Blake", city: "London"},
        ]}

        let(:expected){[
          { city: "London", suppliers: Relation(name: ["Smith", "Blake"]) },
          { city: "Paris",  suppliers: Relation(name: ["Jones"])          },
        ].to_set}

        it 'should group specified attributes' do
          op = Group::Hash.new(operand, AttrList[:name], :suppliers, false)
          op.to_set.should eq(expected)
        end

        it 'should allow specifying allbut grouping' do
          op = Group::Hash.new(operand, AttrList[:city], :suppliers, true)
          op.to_set.should eq(expected)
        end
      end

      context 'in presence of null values' do
        let(:operand){[
          {name: "Smith", city: "London" },
          {name: nil,     city: "Paris"  },
          {name: "Blake", city: "London" },
        ]}

        let(:expected){[
          { city: "London", suppliers: Relation(name: ["Smith", "Blake"]) },
          { city: "Paris",  suppliers: Relation(name: [nil])              },
        ].to_set}

        it 'should not fail' do
          op = Group::Hash.new(operand, AttrList[:name], :suppliers, false)
          op.to_relation
          op.to_set.should eq(expected)
        end
      end

    end
  end # module Engine
end # module Alf
