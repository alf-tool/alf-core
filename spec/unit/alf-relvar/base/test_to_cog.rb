require 'spec_helper'
module Alf
  module Relvar
    describe Base, "to_cog" do

      let(:rv)        { Base.new(:suppliers, connection) }
      let(:connection){ self                             }

      def cog(*args)
        @seen = args
      end

      subject{ rv.to_cog }

      it 'delegates to the connection' do
        subject
        @seen.should eq([:suppliers, rv])
      end

    end
  end
end
