require 'spec_helper'
module Alf
  module Engine
    describe Defaults do

      it 'should work on an empty operand' do
        Defaults.new([], TupleComputation[:id => 1]).to_a.should eq([])
      end

      it 'should replace nil by the default value' do
        rel = [
          {:name => "Jones"},
          {:name => nil}
        ]
        exp = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Defaults.new(rel, TupleComputation[:name => "Smith"]).to_a.should eq(exp)
      end

      it 'should add missing attributes and allow computations' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Jones", :up => "JONES"},
          {:name => "Smith", :up => "SMITH"}
        ]
        defs = TupleComputation[:up => lambda{ name.upcase }]
        Defaults.new(rel, defs).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
