require 'spec_helper'
module Alf
  module Relvar
    describe Base, "heading" do

      let(:rv)        { Base.new(:suppliers, connection) }
      let(:connection){ self                             }

      def heading(*args)
        @seen = args
      end

      subject{ rv.heading }

      it 'delegates to the connection' do
        subject
        @seen.should eq([:suppliers])
      end

    end
  end
end
