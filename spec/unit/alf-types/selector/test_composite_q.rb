require 'spec_helper'
module Alf
  describe Selector, "composite?" do

    subject{ selector.composite? }

    context 'on a single' do
      let(:selector){ Selector.coerce(:name) }

      it { should be_false }
    end

    context 'on a composite' do
      let(:selector){ Selector.coerce([:a, :name]) }

      it { should be_true }
    end

  end
end
