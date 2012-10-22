require 'spec_helper'
module Alf
  describe Relation, '==' do

    let(:heading){ {name: String, status: Integer } }
    let(:reltype){ Relation.type(heading)           }

    subject{ reltype == other }

    context 'with itself' do
      let(:other){ reltype }

      it{ should be_true }
    end

    context 'with another equivalent' do
      let(:other){ Relation.type(heading) }

      it{ should be_true }
    end

    context 'with another, non equivalent' do
      let(:other){ Relation.type(name: String) }

      it{ should be_false }
    end

  end
end
