require 'spec_helper'
module Alf
  module Types
    describe Tuple, "remap" do

      let(:tuple){ Tuple(id: 10, name: "Alf") }

      subject{ tuple.remap{|k,v| v.to_s.length} }

      it { should eq(Tuple(id: 2, name: 3)) }

    end
  end
end
