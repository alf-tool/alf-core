require 'spec_helper'
module Alf
  describe Keys, "select" do

    subject{ keys.select{|k| (k & [:name]).empty? } }

    let(:keys) { 
      Keys[ [:a], [:name], [:last, :name] ]
    }
    let(:expected) { 
      Keys[ [:a] ]
    }

    it{ should eq(expected) }

  end
end