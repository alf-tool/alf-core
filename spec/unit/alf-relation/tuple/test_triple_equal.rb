require 'spec_helper'
module Alf
  describe Tuple, "===" do

    let(:type){ Tuple[price: Float] }

    subject{ type === tuple }

    context 'when applied to a most specific tuple than declared' do
      let(:tuple){ Tuple[price: Numeric].new(price: 12.0) }

      it{
        pending("most-specific types not implemented"){ should be_true }
      }
    end
  end
end
