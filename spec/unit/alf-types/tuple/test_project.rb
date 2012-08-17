require 'spec_helper'
module Alf
  module Types
    describe Tuple, "project" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.project([:name]) }

      it 'returns a Hash' do
        subject.should eq(:name => "Alf")
      end

      it 'extends it with Tuple' do
        subject.should be_a(Tuple)
      end

      it 'does not create nil for missing entries' do
        tuple.project([:none]).should eq({})
      end

    end
  end
end