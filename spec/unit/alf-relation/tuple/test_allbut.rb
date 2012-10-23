require 'spec_helper'
module Alf
  module Types
    describe Tuple, "allbut" do

      let(:tuple){ Tuple(:id => 1, :name => "Alf") }

      subject{ tuple.allbut([:name]) }

      it { should eq(Tuple(:id => 1)) }

    end
  end
end