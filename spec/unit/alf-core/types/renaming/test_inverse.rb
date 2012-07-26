require 'spec_helper'
module Alf
  describe Renaming, "inverse" do

    let(:renaming){ Renaming[:old => :new, :foo => :bar] }

    let(:expected){ Renaming[:new => :old, :bar => :foo] }

    subject{ renaming.inverse }

    it{ should eq(expected) }

  end
end