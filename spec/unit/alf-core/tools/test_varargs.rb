require 'spec_helper'
module Alf
  describe "Tools#varargs" do

    it "should work with exact arguments" do
      Tools.varargs([1, "hello"], [Integer, String]).should eq([1, "hello"])
    end

    it "should work when some args are missing" do
      Tools.varargs(["hello"], [Integer, String]).should eq([nil, "hello"])
      Tools.varargs([1, 2], [Integer, String, Integer]).should eq([1, nil, 2])
    end

    it 'should work when no arguments are passed at all' do
      Tools.varargs([], [Integer, String]).should eq([nil, nil])
    end

  end
end
