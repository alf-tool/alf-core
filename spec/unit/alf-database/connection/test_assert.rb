require 'spec_helper'
module Alf
  class Database
    describe Connection, "assert!" do

      let(:conn){ sap_conn }

      context 'with the result is not empty' do
        subject{ conn.assert!{ suppliers } }

        it{ should be_true }
      end

      context 'with the result is empty' do
        subject{ conn.assert!{ restrict(suppliers, ->{false}) } }

        it 'raises a AssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError)
        end
      end

      context 'with an error message' do
        subject{ conn.assert!("foo"){ restrict(suppliers, ->{false}) } }

        it 'raises a AssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError, /foo/)
        end
      end

    end
  end
end
