require 'spec_helper'
module Alf
  describe Keys, "if_empty" do

    context 'with an arg' do
      subject{ keys.if_empty([ [:foo] ]) }

      context 'when empty' do
        let(:keys){ Keys[] }
        let(:expected){ Keys[ [:foo] ] }

        it{ should eq(expected) }
      end

      context 'when not empty' do
        let(:keys){ Keys[ [:a] ] }

        it{ should be(keys) }
      end
    end

    context 'with a block' do
      subject{ keys.if_empty{ [ [:foo] ] } }

      context 'when empty' do
        let(:keys){ Keys[] }
        let(:expected){ Keys[ [:foo] ] }

        it{ should eq(expected) }
      end

      context 'when not empty' do
        let(:keys){ Keys[ [:a] ] }

        it{ should be(keys) }
      end
    end

  end
end