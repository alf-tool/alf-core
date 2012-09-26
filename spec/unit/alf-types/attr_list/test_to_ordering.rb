require 'spec_helper'
module Alf
  describe AttrList, "to_ordering" do

    let(:attrs){ [:a, :b] }

    describe "without direction" do
      subject{ AttrList.coerce(attrs).to_ordering }
      it{ should eq(Ordering.new [[:a, :asc], [:b, :asc]])}
    end

    describe "with a direction" do
      subject{ AttrList.coerce(attrs).to_ordering(direction) }
      let(:direction){ :desc }
      it{ should eq(Ordering.new [[:a, :desc], [:b, :desc]])}
    end

  end
end
