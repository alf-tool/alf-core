require 'spec_helper'
module Alf
  module Engine
    describe Concat do

      it 'should work on no operand at all' do
        Concat.new([]).to_a.should eq([])
      end

      it 'should work with only one operand' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Concat.new([rel]).to_a.should eq(rel)
      end

      it 'should work with multiple operands' do
        rel = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        rel2 = [
          {:name => "Jones"},
          {:name => "Clark"}
        ]
        exp = [
          {:name => "Jones"},
          {:name => "Smith"},
          {:name => "Jones"},
          {:name => "Clark"}
        ]
        Concat.new([rel, rel2]).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
