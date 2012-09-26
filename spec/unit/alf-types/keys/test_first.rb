require 'spec_helper'
module Alf
  describe Keys, "first" do

    subject{ keys.first }

    let(:keys) { 
      Keys[ [:a], [:name], [:last, :name] ]
    }
    let(:expected) { 
      AttrList[:a]
    }

    it{ should eq(expected) }

  end
end