require 'spec_helper'
module Alf
  class Database
    describe Connection, "new" do

      let(:connection_handler){ ->(opts){ "a connection" } }

      subject{ Connection.new(self, &connection_handler) }

      it 'should open the physical connection right away' do
        subject.should_not be_closed
        subject.adapter_connection.should eq("a connection")
      end

    end
  end
end
