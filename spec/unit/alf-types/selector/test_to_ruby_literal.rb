require 'spec_helper'
module Alf
  describe Selector, "to_ruby_literal" do

    subject{ selector.to_ruby_literal }

    context 'on a single' do
      let(:selector){ Selector.coerce(:name) }

      it { should eq('Alf::Selector[:name]') }
    end

    context 'on a composite' do
      let(:selector){ Selector.coerce([:a, :name]) }

      it { should eq('Alf::Selector[[:a, :name]]') }
    end

  end
end
