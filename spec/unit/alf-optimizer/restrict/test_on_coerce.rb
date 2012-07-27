require 'optimizer_helper'
module Alf
  class Optimizer
    describe Restrict, "on_coerce" do

      let(:inside)  { an_operand }
      let(:coercion){ Heading.coerce(:x => Integer) }
      let(:expr)    { restrict(coerce(inside, coercion), predicate) }

      subject{ Restrict.new.call(expr) }

      context 'when the restriction does not apply to x' do
        let(:predicate){ comp(:y => 12) }
        let(:expected) { coerce(restrict(inside, predicate), coercion) }

        it{ should eq(expected) }
      end

      context 'when the restriction applies to x' do
        let(:predicate){ comp(:x => 12) }

        it{ should eq(expr) }
      end

      context 'when the restriction applies to x and other fields in a COMP' do
        let(:predicate){ comp(:y => 12, :x => 13) }
        let(:expected){
          restrict(coerce(restrict(inside, comp(:y => 12)), coercion), comp(:x => 13))
        }

        it{ should eq(expected) }
      end

      context 'when the restriction applies to x and other fields in a OR' do
        let(:predicate){ comp(:y => 12) | comp(:x => 13) }

        it{ should eq(expr) }
      end

    end
  end
end