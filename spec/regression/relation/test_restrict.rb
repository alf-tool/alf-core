require 'spec_helper'
module Alf
  describe Relation, ".restrict bugs" do

    let(:arg){
      Relation([
        { sid: "S1", supplies: Relation(pid: ["P1", "P2"]) },
        { sid: "S5", supplies: Relation([]) }
      ])
    }

    context 'on Relation' do
      subject{ arg.restrict(sid: 'S5') }

      it 'works' do
        pending("most-specific types issue"){
          subject.should be_a(Relation)
        }
      end
    end

  end
end