require 'spec_helper'
module Alf
  class Predicate
    describe Identifier, "and_split" do

      let(:predicate){ Factory.identifier(:id) }
      let(:tautology){ Factory.tautology    }

      subject{ predicate.and_split(list) }

      context 'when included' do
        let(:list){ AttrList[:id, :name] }

        it{ should eq([predicate, tautology]) }
      end

      context 'when not include' do
        let(:list){ AttrList[:name] }

        it{ should eq([tautology, predicate]) }
      end

    end
  end
end