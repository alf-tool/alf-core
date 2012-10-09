require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "keys" do

      let(:rv){ Virtual.new(self, :connection) }

      def keys
        "some keys"
      end

      subject{ rv.keys }

      it 'delegates to the expression' do
        subject.should eq("some keys")
      end

    end
  end
end
