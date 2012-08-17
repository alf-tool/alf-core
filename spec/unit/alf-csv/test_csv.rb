require 'spec_helper'
module Alf
  describe CSV do

    it "should have a version number" do
      CSV.const_defined?(:VERSION).should be_true
    end

  end
end