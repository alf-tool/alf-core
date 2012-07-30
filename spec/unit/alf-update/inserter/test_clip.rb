require 'update_helper'
module Alf
  module Update
    describe Inserter, 'clip' do

      let(:expr)     { clip(suppliers, [:name]) }
      let(:inserted) { [ {:name => "Jones"} ]   }
      let(:expected) { [ {:name => "Jones"} ]   }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        pending "defaults" do
          subject
          context.requests.should eq([ [:insert, :suppliers, expected] ])
        end
      end

    end
  end
end