require File.expand_path('../../sequel_helper', __FILE__)
module Alf
  module Sequel
    describe Adapter, "with_connection" do
      include TestHelper

      let(:adapter){ sequel_adapter }

      def subject(options = {})
        adapter.with_connection(options) do |db|
          yield(db)
        end
      end

      context 'without options' do

        it 'yields a Sequel::Database' do
          subject do |db|
            db.should be_a(::Sequel::Database)
          end
        end

        it 'encloses a main transaction' do
          lambda{
            subject do |db|
              raise ::Sequel::Rollback
            end
          }.should_not raise_error(::Sequel::Rollback)
        end
      end

    end
  end
end