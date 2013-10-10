require 'spec_helper'
module Alf
  module Support
    describe Tree, "to_text" do

      let(:tree){
        [:hello, [:world], [:and, [:me], [:alf, [:block], [:grant]]], [:and, [:you]]]
      }

      let(:expected){
        "hello\n+-- world\n+-- and\n|  +-- me\n|  +-- alf\n|     +-- block\n|     +-- grant\n+-- and\n   +-- you\n"
      }

      subject{ Alf::Support::Tree.new(tree).to_s }

      it{ should eq(expected) }

    end
  end
end
