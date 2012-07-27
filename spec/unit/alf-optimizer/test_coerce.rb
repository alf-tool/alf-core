require 'optimizer_helper'
module Alf
  describe "coerce" do

    subject{ coerce(an_operand, :y => Integer) }

    let(:split_attributes){ subject.coercions.to_attr_list }

    it_should_behave_like "a split-able expression for restrict"

  end
end