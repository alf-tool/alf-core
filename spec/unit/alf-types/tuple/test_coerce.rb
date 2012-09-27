require 'spec_helper'
module Alf
  module Types
    describe Tuple, "coerce" do

      let(:tuple){ Tuple(:id => "1", :name => "Alf") }

      subject{ tuple.coerce(:id => Integer) }

      it { should eq(Tuple.new(:id => 1, :name => "Alf")) }

    end
  end
end