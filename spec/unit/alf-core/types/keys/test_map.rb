require 'spec_helper'
module Alf
  describe Keys, "map" do

    subject{ keys.map{|k| k | [:foo] } }

    let(:keys) { 
      Keys[ [:a], [:name] ]
    }
    let(:expected) { 
      Keys[ [:a, :foo], [:name, :foo] ]
    }

    it{ should eq(expected) }

  end
end