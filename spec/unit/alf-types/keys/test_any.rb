require 'spec_helper'
module Alf
  describe Keys, "any?" do

    subject{ keys.any?{|k| (k & [:name]).empty? } }

    let(:keys) { 
      Keys[ [:a], [:name], [:last, :name] ]
    }
    let(:expected) { 
      Keys[ [:a] ]
    }

    it{ should be_true }

  end
end