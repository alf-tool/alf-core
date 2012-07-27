require 'optimizer_helper'
module Alf
  describe "sort" do

    subject{ sort(an_operand, [[:x, :asc]]) }

    it_behaves_like "a pass-through expression for restrict"

  end
end