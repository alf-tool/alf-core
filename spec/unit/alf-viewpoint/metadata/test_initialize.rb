require 'spec_helper'
module Alf
  module Viewpoint
    describe Metadata, "#initialize" do

      context 'without args' do
        subject{ Metadata.new }

        it 'has empty expectations' do
          subject.expectations.should eq([])
        end

        it 'has empty dependencies' do
          subject.dependencies.should eq({})
        end
      end

      context 'with args' do
        subject{ Metadata.new([1], {:a => 2}) }

        it 'has empty expectations' do
          subject.expectations.should eq([1])
        end

        it 'has empty dependencies' do
          subject.dependencies.should eq({:a => 2})
        end
      end

    end
  end
end
