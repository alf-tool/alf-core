require 'optimizer_helper'
module Alf
  describe "extend" do

    subject{ extend(an_operand, :y => "x.upcase") }

    let(:split_attributes){ subject.ext.to_attr_list }

    it_should_behave_like "a split-able expression for restrict"

  end
end