require 'spec_helper'
module Alf
  describe Keys, "all?" do

    subject{ keys.all?{|k| (k & [:name]).empty? } }

    let(:keys) { 
      Keys[ [:a], [:name], [:last, :name] ]
    }
    let(:expected) { 
      Keys[ [:a] ]
    }

    it{ should be_false }

  end
end