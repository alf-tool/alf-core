require File.expand_path('../../sequel_helper', __FILE__)
module Alf
  module Sequel
    describe Relvar, 'insert' do
      include TestHelper

      let(:relvar){
        create_names_schema(sequel_names_adapter)
      }

      subject {
        relvar.insert(tuples)
      }

      after do
        resulting = relvar.project([:name]).value
        expected  = supplier_names_relation.union Relation(tuples)
        resulting.should eq(expected)
      end

      context 'with a single Hash' do
        let(:tuples){ {:name => "Zurch"} }

        it 'returns a relation with primary keys' do
          subject.should eq(Relation(:id => 6))
        end
      end

      context 'with an iterator of tuples' do
        let(:tuples){ [{:name => "Zurch"}, {:name => "Zurgh"}] }

        it 'returns a relation with primary keys' do
          subject.should eq(Relation(:id => [6, 7]))
        end
      end

    end
  end
end