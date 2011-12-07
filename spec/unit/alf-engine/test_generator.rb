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

    end
  end # module Engine
end # module Alf
