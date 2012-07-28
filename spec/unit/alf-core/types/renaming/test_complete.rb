require 'spec_helper'
module Alf
  describe Renaming, "complete" do

    let(:renaming){ Renaming[:old => :new, :foo => :bar] }

    subject{ renaming.complete(AttrList[:old, :blah]) }

    let(:expected){ Renaming[:old => :new, :foo => :bar, :blah => :blah] }

    it{ should eq(expected) }

  end
end