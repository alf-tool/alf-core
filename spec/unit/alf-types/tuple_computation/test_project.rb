require 'spec_helper'
module Alf
  describe TupleComputation, "project" do
    big = TupleExpression.coerce(->(t){ t.status > 10 })
    who = TupleExpression.coerce(->(t){ t.name })

    let(:comp){
      TupleComputation[big?: big, who: who]
    }

    subject{ comp.project(list, allbut) }

    context 'when not allbut' do
      let(:allbut){ false }

      [
        [ [:big?, :who],  TupleComputation[big?: big, who: who] ],
        [ [:big?],        TupleComputation[big?: big] ],
        [ [:none],        TupleComputation[{}] ],
      ].each do |(attrs,expected)|
        context "on #{attrs}" do
          let(:list){ attrs }

          it{ should eq(expected) }
        end
      end
    end

    context 'when allbut' do
      let(:allbut){ true }

      [
        [ [:big?, :who], TupleComputation[{}] ],
        [ [:big?],       TupleComputation[who: who] ],
        [ [:none],       TupleComputation[big?: big, who: who] ],
      ].each do |(attrs,expected)|
        context "on #{attrs}" do
          let(:list){ attrs }

          it{ should eq(expected) }
        end
      end
    end

  end
end
