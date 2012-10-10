require 'spec_helper'
module Alf
  class Database
    describe Connection, "lock" do

      let(:conn){ sap_conn }

      context 'with a Symbol' do
        subject{ conn.lock(:suppliers, :exclusive){ @seen = true } }

        it 'delegates to the underlying connection' do
          subject
          @seen.should be_true
        end
      end

    end
  end
end
