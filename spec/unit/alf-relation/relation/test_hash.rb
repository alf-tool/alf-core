require 'spec_helper'
module Alf
  describe Relation, 'hash' do

    let(:tuple){ Relation[id: Integer].coerce(id: 12) }

    subject{ tuple.hash == other.hash }

    context 'on purely equal relation' do
      let(:other){ Relation[id: Integer].coerce(id: 12) }

      it{ should be_true }
    end

    context 'on equal relation but a subtype' do
      let(:other){ Relation[id: Fixnum].coerce(id: 12) }

      it{ should be_true }
    end

    context 'on equal relation but a supertype' do
      let(:other){ Relation[id: Numeric].coerce(id: 12) }

      it{ should be_true }
    end

  end
end
