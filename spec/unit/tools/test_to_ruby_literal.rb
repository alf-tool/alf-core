require 'spec_helper'
module Alf
  describe "Tools#to_ruby_literal" do
    
    specify {
      Tools.to_ruby_literal(12).should eql("12")
    }
    
  end
end