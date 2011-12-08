require 'spec_helper'
module Alf
  module Engine
    describe Materialize::Array do

      let(:operand){[
        {:name => "Smith",  :city => "London"},
        {:name => "Jones",  :city => "Paris"},
        {:name => "Blake",  :city => "Athens"},
      ]}

      it 'should act as a normal cog' do
        op = Materialize::Array.new(operand)
        op.to_a.should eq(operand)
      end

      it 'should allow specifying an ordering' do
        op = Materialize::Array.new(operand, Ordering[[:name, :desc]])
        op.to_a.should eq([
          {:name => "Smith",  :city => "London"},
          {:name => "Jones",  :city => "Paris"},
          {:name => "Blake",  :city => "Athens"},
        ])
      end

    end
  end # module Engine
end # module Alf
