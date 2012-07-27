require 'optimizer_helper'
module Alf
  describe "autonum" do

    subject{ autonum(an_operand, :auto) }

    let(:split_attributes){ AttrList[subject.as] }

    it_should_behave_like "a split-able expression for restrict"

  end
end