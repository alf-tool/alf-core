require 'spec_helper'
module Alf
  module Types
    describe Tuple, "coerce" do

      let(:tuple){ Tuple(:id => "1", :name => "Alf") }

      subject{ tuple.coerce(:id => Integer) }

      it 'coerces the attributes' do
        subject.should eq(:id => 1, :name => "Alf")
      end

      it 'extends it with Tuple' do
        subject.should be_a(Tuple)
      end

    end
  end
end