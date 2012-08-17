require 'spec_helper'
module Alf
  describe Heading, "intersection" do

    subject{ left & right }

    context 'with disjoint headings' do
      let(:left) { Heading[:name => String] }
      let(:right){ Heading[:city => String] }

      it{ should eq(Heading[{}]) }
    end

    context 'with non disjoint headings' do
      let(:left) { Heading[:id => Integer, :name => String] }
      let(:right){ Heading[:id => Integer, :status => Integer] }

      it { should eq(Heading[:id => Integer]) }
    end

    context 'with non disjoint headings and sub types' do
      let(:left) { Heading[:id => Fixnum,  :name => String] }
      let(:right){ Heading[:id => Integer, :status => Integer] }

      it { should eq(Heading[:id => Integer]) }
    end

  end
end
