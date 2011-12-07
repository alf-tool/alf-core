require 'spec_helper'
module Alf
  module Engine
    describe Clip do

      it 'should work on an empty operand' do
        Clip.new([], AttrList[:name], true).to_a.should eq([])
        Clip.new([], AttrList[:name], false).to_a.should eq([])
      end

      let(:operand){[
          {:name => "Jones", :city => "London"},
          {:name => "Smith", :city => "Paris"}
      ]}

      it 'should work on a non empty operand' do
        exp = [
          {:name => "Jones"},
          {:name => "Smith"}
        ]
        Clip.new(operand, AttrList[:name], false).to_a.should eq(exp)
      end

      it 'should allow allbut clipping' do
        exp = [
          {:city => "London"},
          {:city => "Paris"}
        ]
        Clip.new(operand, AttrList[:name], true).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
