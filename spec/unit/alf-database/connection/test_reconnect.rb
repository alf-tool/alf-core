require 'spec_helper'
module Alf
  class Database
    describe Connection, "reconnect" do

      let(:connection_handler){ ->(opts){ self } }

      let(:conn){ Connection.new(self, &connection_handler) }

      subject{ conn.reconnect(opts) }

      def close
        @closed = true
      end

      before do
        conn.should_not be_closed
        @closed = false
      end

      context 'when only physical options are changed' do
        let(:opts){ {schema_cache: true} }

        it 'should close the underlying connection' do
          subject
          @closed.should be_true
        end
      end

      context 'when only logical options are changed' do
        let(:opts){ {default_viewpoint: Viewpoint::NATIVE} }

        it 'should not close the underlying connection' do
          subject
          @closed.should be_false
        end
      end

    end
  end
end
