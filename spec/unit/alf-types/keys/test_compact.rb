require 'spec_helper'
module Alf
  describe Keys, "compact" do

    subject{ keys.compact }

    context 'on empty Keys' do
      let(:keys){ Keys[] }

      it{ should eq(Keys[]) }
    end

    context 'on non empty Keys' do
      let(:keys)    { Keys[ [:a], [], [:last, :name] ] }
      let(:expected){ Keys[ [:a], [:last, :name] ] }

      it{ should eq(expected) }
    end

  end
end