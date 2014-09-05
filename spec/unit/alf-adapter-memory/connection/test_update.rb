require 'spec_helper'
module Alf
  class Adapter
    class Memory
      describe Connection, "update" do

        let(:adapter){ Memory.new('memory://') }

        it 'works' do
          adapter.connect do |conn|
            conn.update(:suppliers, {id: 1}, true)
          end
        end

      end # describe Connection
    end # describe Memory
  end # class Adapter
end # module Alf
