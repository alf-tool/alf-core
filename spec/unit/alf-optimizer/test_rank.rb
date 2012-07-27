require 'optimizer_helper'
module Alf
  describe "rank" do

    subject{ rank(an_operand, [[:x, :asc]], :rank) }

    let(:split_attributes){ AttrList[subject.as] }

    it_should_behave_like "a split-able expression for restrict"

  end
end