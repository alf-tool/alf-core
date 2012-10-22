require 'spec_helper'
module Alf
  module Relvar
    describe Base, "insert" do

      let(:rv)        { Base.new(:suppliers, connection) }
      let(:tuples)    { Relation.coerce(:id => 1)        }
      let(:connection){ self                             }

      def insert(*args)
        @seen = args
      end

      subject{ rv.insert(tuples) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, tuples])
      end

    end
  end
end
