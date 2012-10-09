require 'spec_helper'
module Alf
  class Database
    describe Connection, "query" do

      let(:conn){ sap_conn }

      context 'with a leaf operand' do
        subject{ conn.query{ suppliers } }

        it{ should be_a(Relation) }
      end

      context 'with a complex expression' do
        subject{ conn.query{ project(suppliers, [:sid]) } }

        it{ should be_a(Relation) }
      end

    end
  end
end
