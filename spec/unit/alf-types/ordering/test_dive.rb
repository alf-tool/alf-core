require 'spec_helper'
module Alf
  describe Ordering, 'dive' do

    subject{ ordering.dive(:b) }

    context 'when the ordering has :b' do
      let(:ordering){
        Ordering.new([[:a, :asc], [[:b, :x], :asc], [[:b, :y], :asc]])
      }
      let(:expected){
        Ordering.new([[:x, :asc], [:y, :asc]])
      }

      it{ should eq(expected) }
    end

    context 'when the ordering has no :b' do
      let(:ordering){
        Ordering.new([[:a, :asc]])
      }
      let(:expected){
        Ordering::EMPTY
      }

      it{ should eq(expected) }
    end

    context 'when the ordering has a single :b' do
      let(:ordering){
        Ordering.new([[:b, :asc]])
      }
      let(:expected){
        Ordering::EMPTY
      }

      it{ should eq(expected) }
    end

  end
end
