require 'spec_helper'
module Alf
  describe Relation, "equality" do

    let(:rel)   { Relation[id: Integer].coerce(id: 12) }
    let(:subrel){ Relation[id:  Fixnum].coerce(id: 12) }
    let(:suprel){ Relation[id: Numeric].coerce(id: 12) }

    context '==' do

      it 'returns true for all pairs above' do
        rel.should eq(subrel)
        subrel.should eq(rel)
        rel.should eq(suprel)
        suprel.should eq(rel)
        subrel.should eq(suprel)
        suprel.should eq(subrel)
      end

      it 'returns true on empty relations' do
        Relation([]).should eq(Relation([]))
      end

      it 'returns true on empty factored relations' do
        type = Relation[id: Integer]
        type.new(Set.new).should eq(type.new(Set.new))
      end

      it 'returns true on empty recursively defined relations' do
        type = Relation.type(id: Integer){|r| {children: r} }

        type.new(Set.new).should eq(type.new(Set.new))

        tuple = {id: 1, children: []}
        type.coerce(tuple).should eq(type.coerce(tuple))
      end
    end

    context 'eql?' do

      it 'returns true for all pairs' do
        rel.should eql(subrel)
        subrel.should eql(rel)
        rel.should eql(suprel)
        suprel.should eql(rel)
        subrel.should eql(suprel)
        suprel.should eql(subrel)
      end
    end

  end
end
