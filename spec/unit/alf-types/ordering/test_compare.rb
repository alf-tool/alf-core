require 'spec_helper'
module Alf
  describe Ordering, "compare" do

    it "should work on a singleton ordering" do
      key = Ordering.coerce [:a]
      key.compare({:a => 1}, {:a => 2}).should == -1
      key.compare({:a => 1}, {:a => 1}).should == 0
      key.compare({:a => 2}, {:a => 1}).should == 1
    end

    it "should work on singleton when :desc" do
      key = Ordering.coerce [[:a, :desc]]
      key.compare({:a => 1}, {:a => 2}).should == 1
      key.compare({:a => 1}, {:a => 1}).should == 0
      key.compare({:a => 2}, {:a => 1}).should == -1
    end

    it "should work with multiple keys" do
      key = Ordering.coerce [[:a, :asc], [:b, :desc]]
      key.compare({:a => 1, :b => 1}, {:a => 0, :b => 1}).should == 1
      key.compare({:a => -1, :b => 1}, {:a => 0, :b => 1}).should == -1
      key.compare({:a => 0, :b => 1}, {:a => 0, :b => 0}).should == -1
      key.compare({:a => 1, :b => 1}, {:a => 1, :b => 2}).should == 1
      key.compare({:a => 1, :b => 1}, {:a => 1, :b => 1}).should == 0
    end

    it "should work when nils are involved" do
      key = Ordering.coerce [:a]
      key.compare({:a => nil}, {:a => nil}).should == 0
      key.compare({:a => 1}, {:a => nil}).should == 1
      key.compare({:a => nil}, {:a => 1}).should == -1
    end

  end # compare
end # Alf