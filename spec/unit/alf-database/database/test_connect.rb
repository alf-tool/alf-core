require 'spec_helper'
module Alf
  describe Database, 'connect' do

    context 'without a block' do
      subject{ Database.connect(Path.dir) }

      it{ should be_a(Database::Connection) }

      it 'should not be closed' do
        subject.should_not be_closed
      end
    end

    context 'with a block' do
      subject{
        Database.connect(Path.dir){|c| 
          c.should be_a(Database::Connection)
          c.should_not be_closed
          @seen = c
        }
      }

      it 'yields the block with a connection instance' do
        subject
        @seen.should be_a(Database::Connection)
      end

      it 'close the connection at the end' do
        subject
        @seen.should be_closed
      end
    end
    
  end
end