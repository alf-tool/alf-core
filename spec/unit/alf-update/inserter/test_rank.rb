require 'update_helper'
module Alf
  module Update
    describe Inserter, 'rank' do

      let(:expr)     { rank(suppliers, [[:name, :asc]], :rank) }
      let(:inserted) { [ {:rank => 1, :name => "Jones"} ] }
      let(:expected) { [ {:name => "Jones"} ]             }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        db_context.requests.should eq([ [:insert, :suppliers, expected] ])
      end

    end
  end
end