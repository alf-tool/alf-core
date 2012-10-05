require 'spec_helper'
module Alf
  module Relvar
    describe Base, "delete" do

      let(:rv)        { Base.new(connection, :suppliers) }
      let(:predicate) { Predicate.eq(:sid, 1)            }
      let(:connection){ self                             }

      def delete(*args)
        @seen = args
      end

      subject{ rv.delete(predicate) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, predicate])
      end

    end
  end
end
