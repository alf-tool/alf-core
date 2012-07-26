require 'spec_helper'
module Alf
  describe Renaming, "rename_attr_list" do

    let(:renaming){ Renaming[:old => :new, :foo => :bar] }

    let(:expected){ AttrList[:bar, :new, :name] }

    subject{ renaming.rename_attr_list(attr_list) }

    context 'on an attribute list' do
      let(:attr_list){ AttrList[:foo, :old, :name] }

      it{ should eq(expected) }
    end

    context 'on an Array of names' do
      let(:attr_list){ [:foo, :old, :name] }

      it{ should eq(expected) }
    end

  end
end