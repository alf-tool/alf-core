require 'spec_helper'
module Alf
  class Database
    describe Connection, "tuple_extract" do

      let(:conn){ sap_conn }

      context 'when more than one tuple' do
        subject{ conn.tuple_extract{ suppliers } }

        it 'raises a NoSuchTupleError' do
          lambda{
            subject
          }.should raise_error(NoSuchTupleError)
        end
      end

      context 'when zero tuple' do
        subject{ conn.tuple_extract{ restrict(suppliers, ->{ false }) } }

        it 'raises a NoSuchTupleError' do
          lambda{
            subject
          }.should raise_error(NoSuchTupleError)
        end
      end

      context 'when exactly one tuple' do
        subject{ conn.tuple_extract{ restrict(suppliers, ->{ sid == 'S1' }) } }

        it 'returns a Tuple instance' do
          subject.should be_a(Tuple)
        end
      end

    end
  end
end
