require 'spec_helper'
module Alf
  describe Keys, "hash and ==" do

    subject{ left == right }

    after do
      (left.hash == right.hash).should be_true if subject
    end

    context 'on empty Keys' do
      let(:left) { Keys.new [] }
      let(:right){ Keys.new [] }

      it{ should be_true }
    end

    context 'on non-empty equal Keys' do
      let(:left) { Keys.new [ AttrList[], AttrList[:b, :a] ] }
      let(:right){ Keys.new [ AttrList[:a, :b], AttrList[] ] }

      it{ should be_true }
    end

    context 'on non equal Keys' do
      let(:left) { Keys.new [ AttrList[:b, :a] ] }
      let(:right){ Keys.new [ AttrList[:a, :c] ] }

      it{ should be_false }
    end

  end
end