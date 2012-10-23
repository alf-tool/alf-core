require 'spec_helper'
module Alf
  describe Relation, "hash" do

    let(:reltype){ Relation[name: String]                   }
    let(:rel)    { reltype.coerce(name: ["Jones", "Smith"]) }

    subject{ rel.hash == other.hash }

    before do
      (reltype === rel).should be_true
      rel.should be_a(reltype)
    end

    context 'with itself' do
      let(:other){ rel }
    
      it{ should be_true }
    end
    
    context 'with an equivalent based on same type' do
      let(:other){ reltype.coerce(name: ["Smith", "Jones"]) }
    
      it{ should be_true }
    end
    
    context 'with an equivalent based on equivalent type' do
      let(:other){ Relation.coerce(name: ["Smith", "Jones"]) }
    
      it{ should be_true }
    end

  end
end
