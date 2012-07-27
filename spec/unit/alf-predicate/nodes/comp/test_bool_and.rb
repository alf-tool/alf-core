require 'spec_helper'
module Alf
  class Predicate
    describe Comp, "&" do

      let(:left){ Factory.comp(:eq, :x => 2) }
      let(:contradiction){ Factory.contradiction }

      subject{ left & right }

      context 'with a disjoint comp of same kind' do
        let(:right){ Factory.comp(:eq, :y => 3) }

        it{ should eq(Factory.comp(:eq, :x => 2, :y => 3)) }
      end

      context 'with a non disjoint comp of same kind, yet equal' do
        let(:right){ Factory.comp(:eq, :x => 2, :y => 3) }

        it{ should eq(Factory.comp(:eq, :x => 2, :y => 3)) }
      end

      context 'with a non disjoint comp of same kind, not equal' do
        let(:right){ Factory.comp(:eq, :x => 4, :y => 3) }

        it{ should eq(Factory.contradiction) }
      end

      context 'with another comp' do
        let(:right){ Factory.comp(:neq, :x => 4) }

        it{ should be_a(And) }
      end

    end
  end
end