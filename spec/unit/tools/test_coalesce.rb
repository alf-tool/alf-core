require 'spec_helper'
module Alf
  describe "Tools#coalesce" do
    
    it "should support a varargs variant" do
      Tools.coalesce(:a, nil, :b, :c).should eql(:a)
      Tools.coalesce(nil, :a, nil, :b, :c).should eql(:a)
    end
    
    it "should support a block for costly computations" do
      Tools.coalesce(nil){ :hello }.should eql(:hello)
    end
    
  end
end