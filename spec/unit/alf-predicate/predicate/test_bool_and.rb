require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "&" do

      let(:left) { Predicate.coerce(x: 2) }

      subject{ left & right }

      before do
        subject.should be_a(Predicate)
      end

      context 'with itself' do
        let(:right){ left }

        it{ should be(left) }
      end

      context 'with the same expression' do
        let(:right){ Predicate.coerce(x: 2) }

        it{ should be(left) }
      end

      context 'with another predicate' do
        let(:right){ Predicate.coerce(y: 3) }

        it 'should be a expected' do
          subject.to_ruby_code.should eq("->(t){ (t.x == 2) && (t.y == 3) }")
        end
      end

    end
  end
end
