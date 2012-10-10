require 'spec_helper'
module Alf
  module Lang
    describe Lispy do

      let(:lispy){ Lispy.new }

      it 'allows parsing predicate expressions' do
        p = lispy.parse{ eq(:x, 1) & neq(:y, 2) }
        p.should be_a(Alf::Predicate)
      end

    end
  end
end