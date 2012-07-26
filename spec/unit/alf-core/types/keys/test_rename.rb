require 'spec_helper'
module Alf
  describe Keys, "rename" do

    subject{ keys.rename(:name => :nome) }

    context 'on empty Keys' do
      let(:keys){ Keys[] }

      it{ should eq(Keys[]) }
    end

    context 'on non empty Keys' do
      let(:keys)    { Keys[ [:a], [:name], [:last, :name] ] }
      let(:expected){ Keys[ [:a], [:nome], [:last, :nome] ] }

      it{ should eq(expected) }
    end

  end
end