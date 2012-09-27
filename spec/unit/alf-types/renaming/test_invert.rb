require 'spec_helper'
module Alf
  describe Renaming, "invert" do

    let(:renaming){ Renaming[:old => :new, :foo => :bar] }

    let(:expected){ Renaming[:new => :old, :bar => :foo] }

    subject{ renaming.invert }

    it{ should eq(expected) }

  end
end