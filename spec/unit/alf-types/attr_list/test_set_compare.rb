require 'spec_helper'
module Alf
  describe AttrList, 'set_compare' do

    subject{ left.set_compare(right) }

    let(:left){ AttrList[:id, :name] }

    context 'when equal' do
      let(:right){ AttrList[:name, :id] }

      it{ should eq(0) }
    end

    context 'when a superset' do
      let(:right){ AttrList[:name] }

      it{ should eq(1) }
    end

    context 'when a subset' do
      let(:right){ AttrList[:name, :id, :status] }

      it{ should eq(-1) }
    end

    context 'when a disjoint' do
      let(:right){ AttrList[:status] }

      it{ should be_nil }
    end

    context 'when a mix' do
      let(:right){ AttrList[:id, :status] }

      it{ should be_nil }
    end

    context 'with an empty one' do
      let(:right){ AttrList[] }

      it{ should eq(1) }
    end

    context 'with two emptis' do
      let(:left) { AttrList[] }
      let(:right){ AttrList[] }

      it{ should eq(0) }
    end

    context 'with something else than an AttrList' do
      let(:right){ :foo }

      it{ should be_nil }
    end

  end
end