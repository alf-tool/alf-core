require 'optimizer_helper'
module Alf
  describe "rename" do

    subject{ rename(an_operand, renaming) }

    context 'on a fully known predicate' do
      let(:predicate){ Predicate.eq(:y, 2) & Predicate.eq(:foo => 3) }
      let(:renaming) { {:x => :y} }

      let(:replaced_predicate){
        Predicate.eq(:x, 2) & Predicate.eq(:foo => 3)
      }

      it_behaves_like "a pass-through expression for restrict"
    end

    context 'on a native predicate' do
      let(:predicate){ Predicate.native(->(t){ t.x == 2 }) }
      let(:renaming) { {:x => :y} }

      it_behaves_like "an unoptimizable expression for restrict"
    end

  end
end