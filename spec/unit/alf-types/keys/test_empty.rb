require 'spec_helper'
module Alf
  describe Keys, "empty?" do

    subject{ keys.empty? }

    context 'on empty Keys' do
      let(:keys){ Keys.new [] }

      it{ should be_true }
    end

    context 'on non empty Keys' do
      let(:keys){ Keys.new [ AttrList[:a] ] }

      it{ should be_false }
    end

  end
end