require 'spec_helper'
module Alf
  module Engine
    describe SetAttr do

      it 'should work on an empty operand' do
        SetAttr.new([], TupleComputation[{}]).to_a.should eq([])
      end

      it 'should allow implementing UPDATE' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "JONES"},
          {:name => "SMITH"}
        ]
        comp = TupleComputation[:name => lambda{ name.upcase }]
        SetAttr.new(rel, comp).to_a.should eq(exp)
      end

      it 'should allow implementing EXTEND' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Jones", :up => "JONES"},
          {:name => "Smith", :up => "SMITH"}
        ]
        comp = TupleComputation[:up => lambda{ name.upcase }]
        SetAttr.new(rel, comp).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
