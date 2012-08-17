require 'spec_helper'
module Alf
  describe Keys, "reject" do

    subject{ keys.reject{|k| (k & [:name]).empty? } }

    let(:keys) { 
      Keys[ [:a], [:name], [:last, :name] ]
    }
    let(:expected) { 
      Keys[ [:name], [:last, :name] ]
    }

    it{ should eq(expected) }

  end
end