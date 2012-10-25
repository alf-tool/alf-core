require 'spec_helper'
module Alf
  describe Relation, "equality" do

    let(:rel)   { Relation[id: Integer].coerce(id: 12) }
    let(:subrel){ Relation[id:  Fixnum].coerce(id: 12) }
    let(:suprel){ Relation[id: Numeric].coerce(id: 12) }

    context '==' do

      it 'returns true for all pairs' do
        rel.should eq(subrel)
        subrel.should eq(rel)
        rel.should eq(suprel)
        suprel.should eq(rel)
        subrel.should eq(suprel)
        suprel.should eq(subrel)
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
