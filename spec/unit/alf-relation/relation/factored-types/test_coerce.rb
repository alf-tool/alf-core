require 'spec_helper'
module Alf
  describe Relation, '.coerce' do

    subject{ type.coerce(tuples) }

    context 'on single attributes' do
      let(:type)    { Relation[name: String,  status: Integer] }
      let(:expected){ Relation(name: "Smith", status: 20)      }

      it 'coerces attributes' do
        pending { subject.should eq(expected) }
      end
    end

  end
end
