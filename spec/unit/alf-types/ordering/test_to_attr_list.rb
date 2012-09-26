require 'spec_helper'
module Alf
  describe Ordering, "to_attr_list" do

    it 'should work on an empty ordering' do
      Ordering.new([]).to_attr_list.should eq(AttrList.new [])
    end

    it 'should return the correct list of attribute names' do
      Ordering.new([[:a, :asc], [:b, :desc]]).to_attr_list.should eq(AttrList[:a, :b])
    end

  end # Ordering
end # Alf
