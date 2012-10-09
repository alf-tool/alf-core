require 'spec_helper'
module Alf
  class Adapter
    class Connection
      [ :cog, :closed?, :close, :in_transaction ].each do |meth|
        describe SchemaCached, "#{meth}" do
          let(:connection_method){ meth.to_sym }

          it_should_behave_like 'an uncached connection method'
        end
      end
    end
  end
end
