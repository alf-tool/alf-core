require 'spec_helper'
module Alf
  describe Operator::Relational do
    
    specify "each" do
      x = []
      Operator::Relational.each{|m| x << m}
      x.sort{|m1,m2| m1.name.to_s <=> m2.name.to_s}.should == [
        Alf::Operator::Relational::Extend,
        Alf::Operator::Relational::Group,
        Alf::Operator::Relational::Heading,
        Alf::Operator::Relational::Intersect,
        Alf::Operator::Relational::Join,
        Alf::Operator::Relational::Matching,
        Alf::Operator::Relational::Minus,
        Alf::Operator::Relational::NotMatching,
        Alf::Operator::Relational::Project,
        Alf::Operator::Relational::Quota,
        Alf::Operator::Relational::Rank,
        Alf::Operator::Relational::Rename,
        Alf::Operator::Relational::Restrict,
        Alf::Operator::Relational::Summarize,
        Alf::Operator::Relational::Ungroup,
        Alf::Operator::Relational::Union,
        Alf::Operator::Relational::Unwrap,
        Alf::Operator::Relational::Wrap,
      ]
    end
    
  end
end
