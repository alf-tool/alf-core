require 'spec_helper'
module Alf
  module Lang
    describe Lispy do

      context 'when unbound' do
        let(:lispy){ Lispy.new }

        it 'allows parsing predicate expressions' do
          p = lispy.parse{ eq(:x, 1) & neq(:y, 2) }
          p.should be_a(Alf::Predicate)
        end

        it 'allows parsing relational expressions' do
          p = lispy.parse{ project(:suppliers, [:sid]) }
          p.should be_a(Algebra::Project)
        end
      end

      context 'when bound' do
        let(:lispy){ Lispy.new([], 12) }

        it 'allows parsing predicate expressions' do
          p = lispy.parse{ eq(:x, 1) & neq(:y, 2) }
          p.should be_a(Alf::Predicate)
        end

        it 'deeply binds parsed relational expressions' do
          p = lispy.parse{ project(:suppliers, [:sid]) }
          p.should be_a(Algebra::Project)
        end
      end

    end
  end
end
