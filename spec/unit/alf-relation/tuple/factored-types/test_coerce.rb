require 'spec_helper'
module Alf
  describe Tuple, '.coerce' do

    subject{ tuple_type.coerce(tuple) }

    context 'on single attributes' do
      let(:tuple_type){ Tuple[name: String,  status: Integer] }
      let(:tuple)     { {name: "Jones", status: "20"}         }

      it 'coerces the attributes' do
        subject.should be_a(Tuple)
        subject.should be_a(tuple_type)
        subject.to_hash.should eq(name: "Jones", status: 20)
      end
    end

  end
end
