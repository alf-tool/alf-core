require 'optimizer_helper'
module Alf
  describe "intersect" do

    subject{ intersect(an_operand, an_operand) }

    it_behaves_like "a pass-through expression for restrict"

  end
end