require 'spec_helper'
module Alf
  describe Ordering, "[]" do

    let(:ordering){ Ordering.new([[:a, :asc], [:b, :desc], [[:c, :d], :asc]]) }

    it 'return the direction when an attribute' do
      ordering[:a].should eq(:asc)
      ordering[:b].should eq(:desc)
      ordering[Selector[:a]].should eq(:asc)
      ordering[Selector[:b]].should eq(:desc)
      ordering[Selector[[:c, :d]]].should eq(:asc)
    end

    it 'return nil when not an attribute' do
      ordering[:c].should be_nil
    end

  end # Ordering
end # Alf
