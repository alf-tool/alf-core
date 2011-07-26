require 'spec_helper'
module Alf
  describe AttrName do
    
    it "should allow normal names" do
      (AttrName === :city).should be_true
    end
    
    it "should allow underscores" do
      (AttrName === :my_city).should be_true
    end
    
    it "should allow numbers" do
      (AttrName === :city2).should be_true
    end
    
  end
end
