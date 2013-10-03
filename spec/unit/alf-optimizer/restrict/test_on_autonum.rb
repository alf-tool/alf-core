require 'optimizer_helper'
module Alf
  class Optimizer
    describe Restrict, "on_autonum" do

      let(:inside){ an_operand }
      let(:expr)  { restrict(autonum(inside, :auto), predicate) }

      subject{ Restrict.new.call(expr) }

      context 'when the restriction does not apply to auto at all' do
        let(:predicate){ comp(:x => 12) }
        let(:expected) { autonum(restrict(inside, predicate), :auto) }
      
        it{ should eq(expected) }
      end
      
      context 'when the restriction applies to auto only' do
        let(:predicate){ comp(:auto => 12) }
      
        it{ should eq(expr) }
      end
      
      context 'when the restriction applies to auto and other fields in a AND' do
        let(:predicate){ comp(:auto => 12, :x => 13) }
        let(:expected){
          restrict(autonum(restrict(inside, comp(:x => 13)), :auto), comp(:auto => 12))
        }
      
        it{ should eq(expected) }
      end

      context 'when the restriction applies to auto and other fields in a OR' do
        let(:predicate){ comp(:auto => 12) | comp(:x => 13) }

        it{ should eq(expr) }
      end

    end
  end
end
