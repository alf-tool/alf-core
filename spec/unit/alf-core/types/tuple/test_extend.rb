require 'spec_helper'
module Alf
  module Types
    describe Tuple, "extend" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.extend(:up => lambda{ name.upcase }) }

      it 'returns a Hash' do
        subject.should eq(:name => "Alf", :up => "ALF")
      end

      it 'extends it with Tuple' do
        subject.should be_a(Tuple)
      end

    end
  end
end