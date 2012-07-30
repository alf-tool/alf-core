require 'update_helper'
module Alf
  module Update
    describe Inserter, 'compact' do

      let(:expr)     { compact(suppliers) }
      let(:inserted) { [ {:name => "Jones"} ] }
      let(:expected) { [ {:name => "Jones"} ] }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        context.requests.should eq([ [:insert, :suppliers, expected] ])
      end

    end
  end
end