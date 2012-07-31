require 'update_helper'
module Alf
  module Update
    describe Inserter, 'restrict' do

      let(:expr)     { restrict(suppliers, :name => "Jones") }
      let(:inserted) { [ { :name => "Jones", :city => "London" } ] }
      let(:expected) { [ { :name => "Jones", :city => "London" } ] }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        db_context.requests.should eq([ [:insert, :suppliers, expected ] ])
      end

    end
  end
end