require 'spec_helper'
module Alf
  module Relvar
    describe Base, "update" do

      let(:rv)        { Base.new(:suppliers, connection) }
      let(:updating)  { {sname: 'Jones'}                 }
      let(:predicate) { Predicate.eq(:sid, 1)            }
      let(:connection){ self                             }

      def update(*args)
        @seen = args
      end

      subject{ rv.update(updating, predicate) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, updating, predicate])
      end

    end
  end
end
