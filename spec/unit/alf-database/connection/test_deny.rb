require 'spec_helper'
module Alf
  class Database
    describe Connection, "deny!" do

      let(:conn){ sap_conn }

      context 'with the result is not empty' do
        subject{ conn.deny!{ suppliers } }

        it 'raises a AssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError)
        end
      end

      context 'with the result is empty' do
        subject{ conn.deny!{ restrict(suppliers, ->{false}) } }

        it{ should be_true }
      end

      context 'with an error message' do
        subject{ conn.deny!("foo"){ suppliers } }

        it 'raises a AssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError, /foo/)
        end
      end

    end
  end
end
