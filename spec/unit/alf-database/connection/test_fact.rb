require 'spec_helper'
module Alf
  class Database
    describe Connection, "fact!" do

      let(:conn){ sap_conn }

      context 'when more than one tuple' do
        subject{ conn.fact!{ suppliers } }

        it 'raises a FactAssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError)
        end
      end

      context 'when zero tuple' do
        subject{ conn.fact!{ restrict(suppliers, ->{ false }) } }

        it 'raises a FactAssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError)
        end
      end

      context 'when exactly one tuple' do
        subject{ conn.fact!{ restrict(suppliers, ->{ sid == 'S1' }) } }

        it 'returns a Tuple instance' do
          subject.should be_a(Tuple)
        end
      end

      context 'with an error message' do
        subject{ conn.fact!("foo"){ suppliers } }

        it 'raises a FactAssertionError' do
          lambda{
            subject
          }.should raise_error(FactAssertionError, /foo/)
        end
      end

    end
  end
end
