require 'spec_helper'
module Alf
  module Types
    describe Tuple, "rename" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.rename(:name => :first_name) }

      it 'renames the attributes' do
        subject.should eq(:id => 1, :first_name => "Alf")
      end

      it 'extends it with Tuple' do
        subject.should be_a(Tuple)
      end

    end
  end
end