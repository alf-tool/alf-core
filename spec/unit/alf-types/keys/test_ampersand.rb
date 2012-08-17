require 'spec_helper'
module Alf
  describe Keys, "&" do

    subject{ left & right }

    context 'when disjoint' do
      let(:left) { Keys[ [:a] ] }
      let(:right){ Keys[ [:b] ] }

      let(:expected){ Keys[ ] }

      it{ should eq(expected) }
    end

    context 'when not disjoint' do
      let(:left) { Keys[ [:a, :b], [:c] ] }
      let(:right){ Keys[ [:d], [:b, :a] ] }

      let(:expected){ Keys[ [:a, :b] ] }

      it{ should eq(expected) }
    end

  end
end