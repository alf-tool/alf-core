require 'optimizer_helper'
module Alf
  describe "infer_heading" do

    subject{ infer_heading(an_operand) }

    it_should_behave_like "an unoptimizable expression for restrict"
  end
end