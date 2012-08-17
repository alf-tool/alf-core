require 'spec_helper'
module Alf
  module Types
    describe Tuple, "only" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.only(:name => :first_name) }

      it 'renames the attributes' do
        subject.should eq(:first_name => "Alf")
      end

      it 'extends it with Tuple' do
        subject.should be_a(Tuple)
      end

    end
  end
end