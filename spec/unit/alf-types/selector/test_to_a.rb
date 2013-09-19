require 'spec_helper'
module Alf
  describe Selector, "to_a" do

    subject{ selector.to_a }

    context 'on a single' do
      let(:selector){ Selector.coerce(:name) }

      it { should eq([:name]) }
    end

    context 'on a composite' do
      let(:selector){ Selector.coerce([:a, :name]) }

      it { should eq([:a, :name]) }
    end

  end
end
