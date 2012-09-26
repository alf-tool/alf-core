require 'spec_helper'
module Alf
  describe AttrName, "===" do

    it "should allow normal names" do
      (AttrName === :city).should be_true
    end

    it "should allow underscores" do
      (AttrName === :my_city).should be_true
    end

    it "should allow numbers" do
      (AttrName === :city2).should be_true
    end

    it "should allow question marks and bang" do
      (AttrName === :big?).should be_true
      (AttrName === :big!).should be_true
    end

    it "should not allow strange attribute names" do
      (AttrName === "$$$".to_sym).should be_false
    end

  end
end
