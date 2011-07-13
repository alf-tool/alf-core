require 'spec_helper'
module Alf
  describe Operator::NonRelational do
    
    specify "each" do
      x = []
      Operator::NonRelational.each{|m| x << m}
      x.sort{|m1,m2| m1.name.to_s <=> m2.name.to_s}.should == [
        Alf::Operator::NonRelational::Autonum,
        Alf::Operator::NonRelational::Clip,
        Alf::Operator::NonRelational::Compact,
        Alf::Operator::NonRelational::Defaults,
        Alf::Operator::NonRelational::Sort,
      ]
    end
    
  end
end