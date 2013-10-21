require 'spec_helper'
module Alf
  describe Ordering, "coerce" do

    context 'with single attribute names' do
      let(:expected){ Ordering.new([[:a, :asc], [:b, :asc]]) }

      it "should work with an Ordering" do
        key  = Ordering.coerce [:a, :b]
        key.should eq(expected)
      end

      it "should work with an empty array" do
        key  = Ordering.coerce []
        key.should eq(Ordering.new([]))
      end

      it "should work with a normalized array" do
        key = Ordering.coerce [[:a, :asc], [:b, :asc]]
        key.should eq(expected)
      end

      it "should work with an array of AttrName" do
        key = Ordering.coerce [:a, :b]
        key.should eq(expected)
      end

      it "should work with an array of Strings" do
        key = Ordering.coerce ["a", "b"]
        key.should eq(expected)
      end

      it "should work with a single array with explicit asc/desc (1)" do
        key = Ordering.coerce [:a, :asc]
        key.should eq(Ordering.new([[:a, :asc]]))
      end

      it "should work with a single array with explicit asc/desc (2)" do
        key = Ordering.coerce [:a, :asc, :b, :desc]
        key.should eq(Ordering.new([[:a, :asc], [:b, :desc]]))
      end

      it "should work with a single array with explicit asc/desc (3)" do
        key = Ordering.coerce ["a", "asc", "b", "desc"]
        key.should eq(Ordering.new([[:a, :asc], [:b, :desc]]))
      end

      it "should work with an AttrList" do
        key = Ordering.coerce(AttrList.new([:a, :b]))
        key.should eq(expected)
      end
    end

    context 'with complex attribute names' do
      let(:expected){ Ordering.new([[:a, :asc], [[:b, :name], :asc]]) }

      it "should work with an array of Strings" do
        key = Ordering.coerce ["a", "b.name"]
        key.should eq(expected)
      end
    end

    context 'coming from ARGV' do
      let(:argv){
        ["city", "asc", "status", "desc", "sid", "asc"]
      }
      let(:expected){
        Ordering.new([[:city, :asc], [:status, :desc], [:sid, :asc]])
      }

      it "should work as expected" do
        Ordering.coerce(argv).should eq(expected)
      end
    end

  end # Ordering
end # Alf
