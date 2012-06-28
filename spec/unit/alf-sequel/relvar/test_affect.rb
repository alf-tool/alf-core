require File.expand_path('../../sequel_helper', __FILE__)
module Alf
  module Sequel
    describe Relvar, 'affect' do
      include TestHelper

      let(:base){
        create_names_schema(sequel_names_adapter)
      }

      subject {
        base.affect(supplier_names_relation)
      }

      it 'returns a relation with ids' do
        subject.should eq(Relation(:id => [6,7,8,9,10]))
      end

      it 'inserts the tuples' do
        subject
        resulting = base.project([:name]).value
        expected  = supplier_names_relation
        resulting.should eq(expected)
      end

    end
  end
end