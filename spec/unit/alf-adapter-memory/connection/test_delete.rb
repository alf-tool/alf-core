require 'spec_helper'
module Alf
  class Adapter
    class Memory
      describe Connection, "delete" do

        let(:adapter){ Memory.new('memory://') }

        it 'works' do
          adapter.connect do |conn|
            conn.delete(:suppliers, true)
          end
        end

      end # describe Connection
    end # describe Memory
  end # class Adapter
end # module Alf
