require 'spec_helper'
module Alf
  describe Tools, "tuple_heading" do

    it 'should work on the empty tuple' do
      Tools.tuple_heading({}).should eq(Heading::EMPTY)
    end

    it 'should work on a supplier-like tuple' do
      expected = Heading[:name => String, :old => FalseClass]
      Tools.tuple_heading(:name => "Jones", :old => false).should eq(expected)
    end

  end
end
