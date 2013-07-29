require 'spec_helper'
module Alf
  class Database
    describe Connection, "migrate" do

      let(:conn){
        Connection.new(self){|opts| @original_opts = opts; self }
      }

      subject{ conn.migrate! }

      def migrate!(opts)
        @seen_opts = opts
      end

      before do
        @seen_opts = nil
      end

      it 'should delegate the call' do
        subject
        @seen_opts.should be(@original_opts)
      end

    end
  end
end
