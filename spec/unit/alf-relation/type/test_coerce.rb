require 'spec_helper'
module Alf
  describe Relation, '.coerce' do

    let(:heading) { Heading.new(name: String, status: Integer) }
    let(:reltype) { Relation.type(heading)                     }
    let(:expected){ Relation(name: "Smith", status: 20)        }

    subject{ reltype.coerce(tuples) }

    context 'coerces attributes' do
      let(:tuples){ Relation(name: "Smith", status: "20") }

      it{ pending { should eq(expected) } }
    end

  end
end
