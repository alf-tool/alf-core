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
    
    it "should not allow strange attribute names" do
      (AttrName === "$$$".to_sym).should be_false
    end
    
    specify "from_argv" do
      AttrName.from_argv(%w{hello}).should eq(:hello)
      AttrName.from_argv(%w{}, :default => :hello).should eq(:hello)
      lambda{
        AttrName.from_argv(%w{hello world})
      }.should raise_error(ArgumentError)
      lambda{
        AttrName.from_argv(%w{})
      }.should raise_error(Myrrha::Error)
    end
    
  end
end
