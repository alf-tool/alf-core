require 'spec_helper'
module Alf
  module Types
    describe Tuple, "only" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.only(:name => :first_name) }

      it { should eq(Tuple.new(:first_name => "Alf")) }

    end
  end
end