require 'spec_helper'
module Alf
  class Predicate
    describe Comp, "and_split" do

      let(:predicate){ Factory.comp(:eq, :x => 2, :y => 3) }
      let(:tautology){ Factory.tautology }

      subject{ predicate.and_split(list) }

      context 'when full at left' do
        let(:list){ AttrList[:x, :y] }

        it{ should eq([predicate.to_raw_expr, tautology]) }
      end

      context 'none at left' do
        let(:list){ AttrList[] }

        it{ should eq([tautology, predicate.to_raw_expr]) }
      end

      context 'none mix' do
        let(:list){ AttrList[:x] }

        it{ should eq([Factory.comp(:eq, :x => 2).to_raw_expr, Factory.comp(:eq, :y => 3).to_raw_expr]) }
      end

      context 'with attributes on both sides' do
        let(:predicate){ Factory.comp(:eq, :x => :y) }

        context 'when full at left' do
          let(:list){ AttrList[:x, :y] }

          it{ should eq([predicate.to_raw_expr, tautology]) }
        end

        context 'none at left' do
          let(:list){ AttrList[] }

          it{ should eq([tautology, predicate.to_raw_expr]) }
        end

        context 'none mix' do
          let(:list){ AttrList[:y] }

          it{ should eq([predicate.to_raw_expr, tautology]) }
        end
      end

    end
  end
end