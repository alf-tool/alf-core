require 'spec_helper'
module Alf
  class Adapter
    class Connection
      describe SchemaCached, "keys" do
        let(:connection_method){ :keys }

        it_should_behave_like 'a cached connection method'
      end
    end
  end
end
