require 'spec_helper'
module Alf
  module Types
    describe Tuple, "project" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.project([:name]) }

      it { should eq(Tuple(:name => "Alf")) }

      it 'does not create nil for missing entries' do
        tuple.project([:none]).should eq(Tuple::EMPTY)
      end

    end
  end
end
