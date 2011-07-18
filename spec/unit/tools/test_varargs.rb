require 'spec_helper'
module Alf
  describe "Tools#varargs" do
    
    specify "with exact args" do
      Tools.varargs([1, "hello"], [Integer, String]).should eq([1, "hello"])
    end
    
    specify "with missing args" do
      Tools.varargs(["hello"], [Integer, String]).should eq([nil, "hello"])
      Tools.varargs([], [Integer, String]).should eq([nil, nil])
      Tools.varargs([1, 2], [Integer, String, Integer]).should eq([1, nil, 2])
    end

  end
end