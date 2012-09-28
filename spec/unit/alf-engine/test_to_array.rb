require 'spec_helper'
module Alf
  module Engine
    describe ToArray do

      it 'should work on an empty operand' do
        ToArray.new([], Ordering[[]]).to_a.should eq([])
      end

      it 'should work with ascending' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        ToArray.new(rel, Ordering[[:name, :asc]]).to_a.should eq(rel)
      end

      it 'should work with descending' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Smith"},
          {:name => "Jones"}
        ]
        ToArray.new(rel, Ordering[[:name, :desc]]).to_a.should eq(exp)
      end

      it 'should work with RVAs' do
        rel = [
          {:name => "Smith", :rva => Relation(:id => [8, 7]) },
          {:name => "Jones", :rva => Relation(:id => [1, 3]) }
        ]
        exp = [
          {:name => "Jones", :rva => [Tuple(:id => 1), Tuple(:id => 3)] },
          {:name => "Smith", :rva => [Tuple(:id => 7), Tuple(:id => 8)] }
        ]
        ToArray.new(rel, Ordering[[:name, :id]]).to_a.should eq(exp)
      end

    end # describe ToArray
  end # module Engine
end # module Alf
