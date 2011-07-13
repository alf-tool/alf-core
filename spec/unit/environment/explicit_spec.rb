require 'spec_helper'
module Alf
  describe Environment::Explicit do
    
    it "should allow branching easily" do
      env = Environment::Explicit.new(:hello => "world")
      env.dataset(:hello).should == "world"
      env = env.branch(:hello => "world2")
      env.dataset(:hello).should == "world2"
      env = env.unbranch
      env.dataset(:hello).should == "world"
    end
    
  end
end