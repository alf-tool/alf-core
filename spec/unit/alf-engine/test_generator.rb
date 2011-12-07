require 'spec_helper'
module Alf
  module Engine
    describe Generator do

      it 'should generate n tuples, from 0' do
        exp = [
          {:id => 0},
          {:id => 1}
        ]
        Generator.new(2, :id).to_a.should eq(exp)
      end

      it 'should allow specifying an offset' do
        exp = [
          {:id => 10},
          {:id => 11}
        ]
        Generator.new(2, :id, 10).to_a.should eq(exp)
      end

      it 'should allow specifying a step' do
        exp = [
          {:id => 10},
          {:id => 15},
          {:id => 20}
        ]
        Generator.new(3, :id, 10, 5).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
