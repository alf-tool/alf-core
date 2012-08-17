require 'spec_helper'
module Alf
  module Algebra
    describe Operator do
    
      specify "each" do
        ops = []
        Operator.each{|m| ops << m}
        nonrel = []
        NonRelational.each{|m| nonrel << m}
        rel = []
        Relational.each{|m| rel << m}
        ops.should == nonrel + rel
      end
    
    end
  end
end