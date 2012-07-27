require 'optimizer_helper'
module Alf
  describe "group" do

    subject{ group(an_operand, [:x, :y], :z) }

    let(:split_attributes){ AttrList[subject.as] }

    it_should_behave_like "a split-able expression for restrict"

  end
end
