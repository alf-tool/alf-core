require 'spec_helper'
module Alf
  describe Relation, '===' do

    let(:reltype){ Relation[heading] }

    subject{ reltype === value }

    context 'when the exact types' do
      let(:heading){ Heading.new(name: String, status: Fixnum) }

      context 'on a valid value built with itself' do
        let(:value){ reltype.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end

      context 'on a valid value but built with Relation' do
        let(:value){ Relation.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end
    end

    context 'with a super type' do
      let(:heading){ Heading.new(name: String, status: Integer) }

      context 'on a valid value built with itself' do
        let(:value){ reltype.coerce(name: "Smith", status: 20) }

        it{ should be_true }
      end

      context 'on a valid value but built with Relation' do
        let(:value){ Relation.coerce(name: "Smith", status: 20) }

        it{ pending("super relation type badly implemented"){ should be_true } }
      end
    end

  end
end
