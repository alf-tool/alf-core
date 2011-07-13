require 'spec_helper'
module Alf
  describe Operator do
    
    specify "each" do
      ops = []
      Operator.each{|m| ops << m}
      nonrel = []
      Operator::NonRelational.each{|m| nonrel << m}
      rel = []
      Operator::Relational.each{|m| rel << m}
      ops.should == nonrel + rel
    end
    
  end
end