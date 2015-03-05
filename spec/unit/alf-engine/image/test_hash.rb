require 'spec_helper'
module Alf
  module Engine
    describe Image::Hash do

      context 'the normal case' do
        let(:left){Relation([
          {sid: "S1", city: "London"},
          {sid: "S2", city: "Paris"},
          {sid: "S3", city: "London"},
          {sid: "S4", city: "Athens"},
        ])}

        let(:right){Relation([
          {city: "London", pid: "P1"},
          {city: "London", pid: "P2"},
          {city: "Paris",  pid: "P1"},
        ])}

        let(:expected_type){
          Relation[pid: String]
        }

        let(:expected){Relation([
          {sid: "S1", city: "London", img: expected_type.coerce([ { pid: "P1" }, { pid: "P2" } ]) },
          {sid: "S2", city: "Paris",  img: expected_type.coerce([ { pid: "P1" } ])},
          {sid: "S3", city: "London", img: expected_type.coerce([ { pid: "P1" }, { pid: "P2" } ])},
          {sid: "S4", city: "Athens", img: expected_type.coerce([ ])},
        ])}

        it 'should group specified attributes' do
          op = Image::Hash.new(left, right, :img)
          op.to_relation.should eq(expected)
        end
      end

      context 'when right is empty' do
        let(:left){Relation([
          {sid: "S1", city: "London"}
        ])}

        let(:right){Relation([
        ])}

        let(:expected){Relation([
          {sid: "S1", city: "London", img: Relation::DUM },
        ])}

        it 'should not fail and behave as expected' do
          op = Image::Hash.new(left, right, :img)
          op.to_relation.should eq(expected)
        end
      end

    end # Image::Hash
  end # module Engine
end # module Alf    

