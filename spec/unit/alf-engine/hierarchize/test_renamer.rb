require 'spec_helper'
module Alf
  module Engine
    describe Hierarchize, "renaming" do

      let(:hierarchize){
        Hierarchize.new([], AttrList[:id, :subid], AttrList[:parent, :subparent], :children)
      }

      subject{
        hierarchize.send(:renamer)
      }

      it{ should eq(Renaming[parent: :id, subparent: :subid]) }

    end
  end
end
