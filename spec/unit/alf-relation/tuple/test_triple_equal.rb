require 'spec_helper'
module Alf
  describe Tuple, "===" do

    subject{ type === tuple }

    context 'when applied to a most specific tuple than declared' do
      let(:type){
        Tuple[price: Float]
      }

      let(:tuple){
        type.new(price: 12.0)
      }

      it{ should be_true }
    end

    context 'when applied to a most specific tuple than declared' do
      let(:type){
        Tuple[price: Float]
      }

      let(:tuple){
        Tuple[price: Numeric].new(price: 12.0)
      }

      it{
        pending("most-specific types not implemented"){ should be_true }
      }
    end

    context 'when nil is used' do
      let(:type){
        Tuple[default: String]
      }
      let(:tuple){
        type.new(:default => nil)
      }

      it{ should be_true }
    end

  end
end
