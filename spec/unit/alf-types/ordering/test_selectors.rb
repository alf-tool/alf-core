require 'spec_helper'
module Alf
  describe Ordering, "selectors" do

    subject{ ordering.selectors }

    context 'with single attribute names' do
      let(:ordering){ Ordering.new([[:a, :asc], [:b, :asc]]) }

      it "works as expected" do
        subject.should eq([:a, :b])
      end
    end

    context 'with complex attribute names' do
      let(:ordering){ Ordering.new([[:a, :asc], [[:b, :name], :asc]]) }
      
      it "works as expected" do
        subject.should eq([:a, [:b, :name]])
      end
    end

  end # Ordering
end # Alf
