require 'spec_helper'
module Alf
  describe Relation, ".coerce bugs" do

    let(:arg){ [Tuple(sid: "S5", suppliers: Relation([]))] }

    context 'on Relation' do
      subject{ Relation.coerce(arg) }

      it 'works' do
        subject.should be_a(Relation)
      end
    end

    context 'on Relation[...]' do
      subject{ Relation[sid: String, suppliers: Relation[{}]].coerce(arg) }

      it 'works' do
        subject.should be_a(Relation)
      end
    end

  end
end