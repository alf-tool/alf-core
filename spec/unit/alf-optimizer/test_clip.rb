require 'optimizer_helper'
module Alf
  describe "clip" do

    subject{ clip(an_operand, [:x, :y]) }

    it_behaves_like "a pass-through expression for restrict"

  end
end