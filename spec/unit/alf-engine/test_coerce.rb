require 'spec_helper'
module Alf
  module Engine
    describe Coerce do

      it 'should work on an empty operand' do
        Coerce.new([], Heading[:price => Float]).to_a.should eq([])
      end

      let(:operand){[
          {:name => "Jones", :price => "12.0"},
          {:name => "Smith", :price => "-10.0"}
      ]}

      it 'should work on a non empty operand' do
        exp = [
          {:name => "Jones", :price => 12.0},
          {:name => "Smith", :price => -10.0}
        ]
        heading = Heading[:name => String, :price => Float]
        Coerce.new(operand, heading).to_a.should eq(exp)
      end

      it 'should not project on the heading' do
        exp = [
          {:name => "Jones", :price => 12.0},
          {:name => "Smith", :price => -10.0}
        ]
        heading = Heading[:price => Float]
        Coerce.new(operand, heading).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
