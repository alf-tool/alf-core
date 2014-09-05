require 'spec_helper'
module Alf
  class Adapter
    class Memory
      describe Connection, "insert" do

        let(:adapter){ Memory.new('memory://') }

        it 'works' do
          adapter.connect do |conn|
            conn.insert(:suppliers, [{foo: "bar"}])
          end
        end

      end # describe Connection
    end # describe Memory
  end # class Adapter
end # module Alf
