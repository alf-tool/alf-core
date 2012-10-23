require 'spec_helper'
module Alf
  describe Tuple, '.coerce' do

    subject{ type.coerce(tuple) }

    context 'on single attributes' do
      let(:type){ Tuple[name: String,  status: Integer] }
      let(:tuple)     { {name: "Jones", status: "20"}         }

      it 'coerces the attributes' do
        subject.should be_a(Tuple)
        subject.should be_a(type)
        subject.to_hash.should eq(name: "Jones", status: 20)
      end
    end

  end
end
