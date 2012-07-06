require 'spec_helper'
module Alf
  module Engine
    describe InferHeading do

      it 'should work on an empty operand' do
        InferHeading.new([]).to_a.should eq([{}])
      end

      it 'should replace nil by the default value' do
        input = [
          {:tested => 1,    :other => "b"},
          {:tested => 10.0, :other => "a"}
        ]
        expected = [
          {:tested => Numeric, :other => String}
        ]
        InferHeading.new(input).to_a.should eq(expected)
      end

    end
  end # module Engine
end # module Alf
