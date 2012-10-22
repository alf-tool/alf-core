require 'spec_helper'
module Alf
  describe Relation, '===' do

    let(:heading){ Heading.new(name: String, status: Integer) }
    let(:reltype){ Relation.type(heading)                     }

    subject{ reltype === value }

    context 'on a valid value built with itself' do
      let(:value){ reltype.new(name: "Smith", status: 20) }

      it{ should be_true }
    end

    context 'on a valid value but built with Relation' do
      let(:value){ Relation(name: "Smith", status: 20) }

      it{ should be_true }
    end

  end
end
