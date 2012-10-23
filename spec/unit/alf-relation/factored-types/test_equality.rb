require 'spec_helper'
module Alf
  describe Relation, '==' do

    let(:reltype){ Relation[name: String, status: Integer] }

    subject{ reltype == other }

    context 'with itself' do
      let(:other){ reltype }

      it{ should be_true }
    end

    context 'with another equivalent' do
      let(:other){ Relation[name: String, status: Integer] }

      it{ should be_true }
    end

    context 'with another, non equivalent' do
      let(:other){ Relation[name: String] }

      it{ should be_false }
    end

  end
end
