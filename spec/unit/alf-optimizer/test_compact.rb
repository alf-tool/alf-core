require 'optimizer_helper'
module Alf
  describe "compact" do

    subject{ compact(an_operand) }

    it_behaves_like "a pass-through expression for restrict"

  end
end