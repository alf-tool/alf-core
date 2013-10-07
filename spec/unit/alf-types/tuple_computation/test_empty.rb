require 'spec_helper'
module Alf
  describe TupleComputation, "empty?" do

    subject{ comp.empty? }

    context 'when not empty' do
      let(:comp){
        TupleComputation[big?: ->{}, who: ->{}]
      }

      it{ should be_false }
    end

    context 'when empty' do
      let(:comp){
        TupleComputation[{}]
      }

      it{ should be_true }
    end

  end
end
