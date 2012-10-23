require 'spec_helper'
module Alf
  describe "Relation#heading" do

    let(:rel){
      Relation([
        {:max => 2,   :name => "Jones"},
        {:max => 7.3, :name => "Jones"},
      ])
    }

    subject{ rel.heading }

    it{ should eq(Heading(:max => Numeric, :name => String)) }

  end
end