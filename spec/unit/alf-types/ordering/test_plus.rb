require 'spec_helper'
module Alf
  describe Ordering, "+" do

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

  end # Ordering
end # Alf
