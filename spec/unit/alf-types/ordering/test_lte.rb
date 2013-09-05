require 'spec_helper'
module Alf
  describe Ordering, "<=" do

    subject{ o1 <= o2 }

    context 'when empty' do
      let(:o1){ Ordering::EMPTY  }
      let(:o2){ Ordering.new([]) }

      it{ should be_true }
    end

    context 'when equal' do
      let(:o1){ Ordering.new([[:a, :asc], [:b, :desc]]) }
      let(:o2){ Ordering.new([[:a, :asc], [:b, :desc]]) }

      it{ should be_true }
    end

    context 'when subsumed' do
      let(:o1){ Ordering.new([[:a, :asc]]) }
      let(:o2){ Ordering.new([[:a, :asc], [:b, :desc]]) }

      it{ should be_true }
    end

    context 'when larger' do
      let(:o1){ Ordering.new([[:a, :asc], [:b, :desc]]) }
      let(:o2){ Ordering.new([[:a, :asc]]) }

      it{ should be_false }
    end

    context 'when different' do
      let(:o1){ Ordering.new([[:a, :asc]]) }
      let(:o2){ Ordering.new([[:a, :desc]]) }

      it{ should be_false }
    end

  end
end