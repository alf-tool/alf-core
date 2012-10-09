require 'spec_helper'
module Alf
  module Relvar
    describe Base, "keys" do

      let(:rv)        { Base.new(:suppliers, connection) }
      let(:connection){ self                             }

      def keys(*args)
        @seen = args
      end

      subject{ rv.keys }

      it 'delegates to the connection' do
        subject
        @seen.should eq([:suppliers])
      end

    end
  end
end
