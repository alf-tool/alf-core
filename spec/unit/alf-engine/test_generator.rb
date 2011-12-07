require 'spec_helper'
module Alf
  module Engine
    describe Generator do

      it 'should generate tuples from 0' do
        exp = [
          {:id => 0},
          {:id => 1}
        ]
        Generator.new(:id, 0, 1, 2).to_a.should eq(exp)
      end

      it 'should allow specifying an offset, step and count' do
        exp = [
          {:id => 10},
          {:id => 15},
          {:id => 20}
        ]
        Generator.new(:id, 10, 5, 3).to_a.should eq(exp)
      end

    end
  end # module Engine
end # module Alf
