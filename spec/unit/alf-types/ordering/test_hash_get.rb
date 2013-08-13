require 'spec_helper'
module Alf
  describe Ordering, "[]" do

    let(:ordering){ Ordering.new([[:a, :asc], [:b, :desc]]) }

    it 'return the direction when an attribute' do
      ordering[:a].should eq(:asc)
      ordering[:b].should eq(:desc)
    end

    it 'return nil when not an attribute' do
      ordering[:c].should be_nil
    end

  end # Ordering
end # Alf
