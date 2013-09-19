require 'spec_helper'
module Alf
  describe Selector, "dive" do

    subject{ selector.dive(:a) }

    context 'on a single, not the same' do
      let(:selector){ Selector.coerce(:name) }

      it { should be_nil }
    end

    context 'on a single, same' do
      let(:selector){ Selector.coerce(:a) }

      it { should be_nil }
    end

    context 'on a composite, starting with' do
      let(:selector){ Selector.coerce([:a, :b, :c]) }

      it { should eq(Selector.coerce([:b, :c])) }
    end

    context 'on a composite, not starting with' do
      let(:selector){ Selector.coerce([:b, :a]) }

      it { should be_nil }
    end

  end
end
