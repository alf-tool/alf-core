require 'spec_helper'
module Alf
  class Database
    describe Connection, "relvar" do

      let(:conn){ sap_conn }

      context 'with a leaf operand' do
        subject{ conn.relvar{ suppliers } }

        it{ should be_a(Relvar::Base) }

        it 'has the expected name' do
          subject.name.should eq(:suppliers)
        end

        it 'is bound to the serving connection' do
          subject.connection!.should be(conn)
        end
      end

      context 'with a complex expression' do
        subject{ conn.relvar{ project(suppliers, [:sid]) } }

        it{ should be_a(Relvar::Virtual) }

        it 'has the expected expression' do
          subject.expr.should be_a(Algebra::Project)
        end

        it 'is bound to the serving connection' do
          subject.connection!.should be(conn)
        end

        it 'has a bound expression as well' do
          subject.expr.connection!.should be(conn)
        end
      end

    end
  end
end
