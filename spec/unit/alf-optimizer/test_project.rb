require 'optimizer_helper'
module Alf
  describe "project" do

    subject{ project(an_operand, [:x, :y]) }

    it_behaves_like "a pass-through expression for restrict"

  end
end