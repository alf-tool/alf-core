require 'spec_helper'
module Alf
  module Relvar
    describe Base, "insert" do

      let(:rv)        { Base.new(:suppliers, connection) }
      let(:connection){ self                             }

      def lock(*args)
        yield(args)
      end

      subject{ rv.lock(:exclusive){|args| @seen = args } }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, :exclusive])
      end

    end
  end
end
