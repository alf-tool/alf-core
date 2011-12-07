require 'spec_helper'
module Alf
  module Engine
    describe Compact do

      it 'should work on an empty operand' do
        Compact.new([]).to_a.should eq([])
      end

      it 'should work when no duplicate is present' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Compact.new(rel).to_set.should eq(rel.to_set)
      end

      it 'should work when duplicates are present' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"},
          {:name => "Jones"},
        ]
        exp = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Compact.new(rel).to_set.should eq(exp.to_set)
      end

    end
  end # module Engine
end # module Alf
