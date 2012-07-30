require 'spec_helper'
module Alf
  class Database
    describe Schema, 'scope' do

      let(:db_class){ 
        Class.new(Database){ 
          helpers{ def foo; end }
          schema(:public) do
            relvar :suppliers
          end
        }
      }
      let(:db){ db_class.new(Connection.folder('.')) }

      subject{ db.schema(:public).scope }

      it 'has algebra methods' do
        subject.respond_to?(:matching).should be_true
      end

      it 'has database helpers' do
        subject.respond_to?(:foo).should be_true
      end

      it 'has schema methods' do
        subject.respond_to?(:suppliers).should be_true
      end

    end
  end
end