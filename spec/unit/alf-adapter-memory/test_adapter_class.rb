require 'spec_helper'
module Alf
  class Adapter
    describe Memory do

      let(:adapter_class){ Memory }

      let(:recognized_conn_specs) do
        [ 'memory://' ]
      end

      it_should_behave_like "an adapter class"

    end # describe Memory
  end # class Adapter
end # module Alf
