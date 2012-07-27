require 'optimizer_helper'
module Alf
  describe "generator" do

    subject{ generator(10, :auto) }

    it_should_behave_like "an unoptimizable expression for restrict"
  end
end