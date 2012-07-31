require 'spec_helper'
module Alf
  describe Renaming, "to_attr_list" do

    let(:renaming){ Renaming[:old => :new, :foo => :bar] }

    subject{ renaming.to_attr_list }

    let(:expected){ AttrList[:old, :foo] }

    it{ should eq(expected) }

  end
end