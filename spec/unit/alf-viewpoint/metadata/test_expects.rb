require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, "#expects" do

      context 'on empty expectations' do
        let(:metadata){ Metadata.new }

        subject{ metadata.expects([1, 2]) }

        it 'sets expectations' do
          subject.expectations.should eq([1, 2])
        end
      end

      context 'on disjoint expectations' do
        let(:metadata){ Metadata.new([1, 2]) }

        subject{ metadata.expects([3, 4]) }

        it 'sets expectations' do
          subject.expectations.should eq([1, 2, 3, 4])
        end
      end

      context 'on overlapping expectations' do
        let(:metadata){ Metadata.new([1, 2]) }

        subject{ metadata.expects([1, 4]) }

        it 'sets expectations' do
          subject.expectations.should eq([1, 2, 4])
        end
      end

    end
  end
end
