require 'spec_helper'
module Alf
  describe TupleComputation, "to_attr_list" do

    it 'should return the correct list of attribute names' do
      list = TupleComputation[
        :big? => lambda{ status > 20 },
        :who  => lambda{ "#{first} #{last}" }
      ].to_attr_list
      list.should be_a(AttrList)
      list.to_a.to_set.should eq([:big?, :who].to_set)
    end

  end
end
