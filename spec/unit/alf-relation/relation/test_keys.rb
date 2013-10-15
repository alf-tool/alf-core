require 'spec_helper'
module Alf
  describe "Relation#keys" do

    let(:rel){
      Relation([
        {:max => 2,   :name => "Jones"},
        {:max => 7.3, :name => "Jones"},
      ])
    }

    subject{ rel.keys }

    it{ should eq(Keys[[:max, :name]]) }

  end
end
