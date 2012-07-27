require 'optimizer_helper'
module Alf
  describe "defaults" do

    subject{ defaults(an_operand, :y => 12) }

    let(:split_attributes){ subject.defaults.to_attr_list }

    it_should_behave_like "a split-able expression for restrict"

  end
end