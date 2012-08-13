require 'spec_helper'
module Alf
  module Types
    describe Tuple, "allbut" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.allbut([:name]) }

      it 'returns a Hash' do
        subject.should eq(:id => 1)
      end

      it 'extends it with Tuple' do
        subject.should be_a(Tuple)
      end

    end
  end
end