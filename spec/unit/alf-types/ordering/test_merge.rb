require 'spec_helper'
module Alf
  describe Ordering, "merge" do

    subject{ Ordering.coerce(left) + right }

    let(:expected){ Ordering.new([[:a, :asc], [:b, :desc]]) }

    describe "with another Ordering" do
      let(:left){ [:a] }
      let(:right){ Ordering.new([[:b, :desc]]) }

      it{ should eq(expected) }
    end

    describe "with  another array" do
      let(:left){ [:a] }
      let(:right){ [[:b, :desc]] }

      it{ should eq(expected) }
    end

    describe "with  another array (2)" do
      let(:left){ [:a] }
      let(:right){ [:b, :desc] }

      it{ should eq(expected) }
    end

    describe "with redundancy" do
      let(:left) { [[:a, :asc], [:b, :desc]] }
      let(:right){ [[:a, :asc], [:c, :desc]] }

      it{ should eq(Ordering.new([[:a, :asc], [:b, :desc], [:c, :desc]])) }
    end

    describe "with conflict and no block" do
      let(:left) { [[:a, :asc], [:b, :desc]] }
      let(:right){ [[:a, :desc], [:c, :desc]] }

      it{ should eq(Ordering.new([[:a, :desc], [:b, :desc], [:c, :desc]])) }
    end

    describe "with conflict and a block" do
      let(:left) { [[:a, :asc], [:b, :desc]] }
      let(:right){ [[:a, :desc], [:c, :desc]] }

      subject{
        Ordering.coerce(left).merge(right){|attr,d1,d2|
          attr.should eq(:a)
          d1.should eq(:asc)
          d2.should eq(:desc)
          d1
        }
      }

      it{ should eq(Ordering.new([[:a, :asc], [:b, :desc], [:c, :desc]])) }
    end

  end # Ordering
end # Alf
