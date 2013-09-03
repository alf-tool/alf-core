require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, "#dup" do

      let(:metadata){ Metadata.new([1, 2], {a: [3, 4]}, [:m]) }

      subject{ metadata.dup }

      it 'should be a different Metadata' do
        subject.should be_a(Metadata)
        subject.should_not be(metadata)
      end

      it 'should have different yet equal expectations' do
        subject.expectations.should_not be(metadata.expectations)
        subject.expectations.should eq(metadata.expectations)
      end

      it 'should have different yet equal dependencies' do
        subject.dependencies.should_not be(metadata.dependencies)
        subject.dependencies.should eq(metadata.dependencies)
      end

      it 'should have different yet equal members' do
        subject.members.should_not be(metadata.members)
        subject.members.should eq(metadata.members)
      end

    end
  end
end
