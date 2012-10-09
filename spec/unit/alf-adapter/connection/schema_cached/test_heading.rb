require 'spec_helper'
module Alf
  class Adapter
    class Connection
      describe SchemaCached, "heading" do
        let(:connection_method){ :heading }

        it_should_behave_like 'a cached connection method'
      end
    end
  end
end
