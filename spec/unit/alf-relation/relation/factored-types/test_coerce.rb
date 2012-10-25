require 'spec_helper'
module Alf
  describe Relation, '.coerce' do

    subject{ type.coerce(tuples) }

    context 'on single attributes' do
      let(:type)    { Relation[name: String,  status: Fixnum]  }
      let(:expected){ Relation(name: "Smith", status: 20)      }
      let(:tuples){
        [ {'name' => "Smith", 'status' => "20"} ]
      }


      it 'coerces attributes' do
        subject.should eq(expected)
      end
    end

    context 'with a relation-valued attribute' do
      let(:type)    { Relation[name: String,  prices: Relation[price: Float]]  }
      let(:expected){ Relation(name: "Smith", prices: Relation(price: [12.0, 14.0])) }
      let(:tuples){
        [{'name' => "Smith", 'prices' => [{'price' => "12.0"}, {'price' => "14.0"}]}]
      }

      it 'coerces the RVA as well' do
        subject.should eq(expected)
      end
    end

  end
end
