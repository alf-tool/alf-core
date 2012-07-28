require 'spec_helper'
module Alf
  class Predicate
    describe DyadicComp, "and_split" do

      let(:predicate){ Factory.eq(:id, 2) }
      let(:tautology){ Factory.tautology  }

      subject{ predicate.and_split(list) }

      context 'when included' do
        let(:list){ AttrList[:id, :name] }

        it{ should eq([predicate, tautology]) }
      end

      context 'when not include' do
        let(:list){ AttrList[:name] }

        it{ should eq([tautology, predicate]) }
      end

      context 'with attributes on both sides' do
        let(:predicate){ Factory.eq(:x, :y) }

        context 'when full at left' do
          let(:list){ AttrList[:x, :y] }
        
          it{ should eq([predicate, tautology]) }
        end
        
        context 'none at left' do
          let(:list){ AttrList[] }
        
          it{ should eq([tautology, predicate]) }
        end

        context 'mix' do
          let(:list){ AttrList[:y] }

          it{ should eq([predicate, tautology]) }
        end
      end

    end
  end
end