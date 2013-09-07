require 'spec_helper'
module Alf
  describe Ordering, "to_attr_list" do

    subject{ ordering.to_attr_list }

    context 'on an empty ordering' do
      let(:ordering){ Ordering::EMPTY }

      it{ should eq(AttrList::EMPTY) }
    end

    context 'on an ordering with single names' do
      let(:ordering){ Ordering.new([[:a, :asc], [:b, :desc]]) }

      it{ should eq(AttrList[:a, :b]) }
    end

    context 'on an ordering with hirarchical names' do
      let(:ordering){ Ordering.new([[[:x, :a], :asc], [:b, :desc]]) }

      it{ should eq(AttrList[:x, :b]) }
    end

  end # Ordering
end # Alf
