require 'spec_helper'
module Alf
  describe Heading, "union" do

    let(:h_name){ Heading[:name => String] }
    let(:h_city){ Heading[:city => String] }

    it "should work on empty headings" do
      Heading::EMPTY.union(Heading::EMPTY).should eq(Heading::EMPTY)
    end

    it "should work with disjoint headings" do
      h_name.union(h_city).should eq(Heading[:name => String, :city => String])
    end

    it "should be aliased as +" do
      (h_name + h_city).should eq(Heading[:name => String, :city => String])
    end

    it "should work compute supertype on non-disjoint headings" do
      h1 = Heading[:age => Fixnum, :name => String]
      h2 = Heading[:age => Integer]
      (h1 + h2).should eq(Heading[:age => Integer, :name => String])
    end

    it "should be aliased as join" do
      h1 = Heading[:age => Fixnum, :name => String]
      h2 = Heading[:age => Integer]
      h1.join(h2).should eq(Heading[:age => Integer, :name => String])
    end

  end 
end
