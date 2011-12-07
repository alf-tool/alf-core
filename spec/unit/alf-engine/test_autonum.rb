require 'spec_helper'
module Alf
  module Engine
    describe Autonum do

      it 'should work on an empty operand' do
        Autonum.new([], :autonum).to_a.should eq([])
      end

      it 'should work on a non empty operand' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        exp = [
          {:name => "Jones", :autoname => 0},
          {:name => "Smith", :autoname => 1}
        ]
        Autonum.new(rel, :autoname).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
