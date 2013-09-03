require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, "#add_members" do

      context 'on empty expectations' do
        let(:metadata){ Metadata.new }

        subject{ metadata.add_members([1, 2]) }

        it 'sets members' do
          subject.members.should eq([1, 2])
        end
      end

      context 'on disjoint members' do
        let(:metadata){ Metadata.new([], {}, [1, 2]) }

        subject{ metadata.add_members([3, 4]) }

        it 'sets members' do
          subject.members.should eq([1, 2, 3, 4])
        end
      end

      context 'on overlapping members' do
        let(:metadata){ Metadata.new([], {}, [1, 2]) }

        subject{ metadata.add_members([1, 4]) }

        it 'sets members' do
          subject.members.should eq([1, 2, 4])
        end
      end

    end
  end
end
