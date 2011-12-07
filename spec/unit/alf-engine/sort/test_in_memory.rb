require 'spec_helper'
module Alf
  module Engine
    describe Sort::InMemory do

      it 'should work on an empty operand' do
        Sort::InMemory.new([], Ordering[[]]).to_a.should eq([])
      end

      it 'should work with ascending' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Sort::InMemory.new(rel, Ordering[[:name, :asc]]).to_a.should eq(rel)
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
        Sort::InMemory.new(rel, Ordering[[:name, :desc]]).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
