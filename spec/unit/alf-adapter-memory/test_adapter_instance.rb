require 'spec_helper'
module Alf
  class Adapter
    describe Memory, "an instance" do

      let(:adapter){ Memory.new('memory://') }

      let(:readable_cogs){
        [ "suppliers", "parts" ]
      }

      it_should_behave_like "an adapter"
      it_should_behave_like "an adapter with readable cogs"

    end # describe Memory
  end # class Adapter
end # module Alf
