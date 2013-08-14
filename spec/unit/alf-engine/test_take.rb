require 'spec_helper'
module Alf
  module Engine
    describe Take do

      it 'should work on an empty operand' do
        Take.new(Leaf.new([]), 1, 1).to_a.should eq([])
      end

      it 'should filter according to the offset' do
        rel = Leaf.new [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Smith"}
        ]
        Take.new(rel, 1, 10).to_a.should eq(exp)
      end

      it 'should filter according to the limit (1/2)' do
        rel = Leaf.new [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Take.new(rel, 0, 2).to_a.should eq(exp)
      end

      it 'should filter according to the limit (2/2)' do
        rel = Leaf.new [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Jones"},
        ]
        Take.new(rel, 0, 1).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
