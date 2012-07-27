require 'spec_helper'
module Alf
  class Predicate
    describe VarRef, "and_split" do

      let(:predicate){ Factory.var_ref(:id) }
      let(:tautology){ Factory.tautology    }

      subject{ predicate.and_split(list, allbut) }

      context '--no-allbut' do
        let(:allbut){ false }

        context 'when included' do
          let(:list){ AttrList[:id, :name] }

          it{ should eq([predicate, tautology]) }
        end

        context 'when not include' do
          let(:list){ AttrList[:name] }

          it{ should eq([tautology, predicate]) }
        end
      end

      context '--allbut' do
        let(:allbut){ true }

        context 'when included' do
          let(:list){ AttrList[:id, :name] }

          it{ should eq([tautology, predicate]) }
        end

        context 'when not include' do
          let(:list){ AttrList[:name] }

          it{ should eq([predicate, tautology]) }
        end
      end

    end
  end
end