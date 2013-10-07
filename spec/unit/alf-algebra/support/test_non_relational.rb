require 'spec_helper'
module Alf
  module Algebra
    describe NonRelational do
    
      specify "each" do
        x = []
        NonRelational.each{|m| x << m}
        x.sort{|m1,m2| m1.name.to_s <=> m2.name.to_s}.should == [
          Autonum,
          Clip,
          Coerce,
          Compact,
          Defaults,
          Generator,
          Sort
        ]
      end
    
    end
  end
end
