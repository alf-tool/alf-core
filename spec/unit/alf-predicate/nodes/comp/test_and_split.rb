require 'spec_helper'
module Alf
  class Predicate
    describe VarRef, "and_split" do

      let(:predicate){ Factory.comp(:eq, :x => 2, :y => 3) }
      let(:tautology){ Factory.tautology }

      subject{ predicate.and_split(list, allbut) }

      context '--no-allbut' do
        let(:allbut){ false }

        context 'when full at left' do
          let(:list){ AttrList[:x, :y] }

          it{ should eq([predicate, tautology]) }
        end

        context 'none at left' do
          let(:list){ AttrList[] }

          it{ should eq([tautology, predicate]) }
        end

        context 'none mix' do
          let(:list){ AttrList[:x] }

          it{ should eq([Factory.comp(:eq, :x => 2), Factory.comp(:eq, :y => 3)]) }
        end
      end

      context '--allbut' do
        let(:allbut){ true }

        context 'when full at left' do
          let(:list){ AttrList[:x, :y] }

          it{ should eq([tautology, predicate]) }
        end

        context 'none at left' do
          let(:list){ AttrList[] }

          it{ should eq([predicate, tautology]) }
        end

        context 'none mix' do
          let(:list){ AttrList[:x] }

          it{ should eq([Factory.comp(:eq, :y => 3), Factory.comp(:eq, :x => 2)]) }
        end
      end

    end
  end
end