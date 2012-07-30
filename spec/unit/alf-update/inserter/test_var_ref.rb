require 'update_helper'
module Alf
  module Update
    describe Inserter, 'var_ref' do

      let(:expr)     { suppliers          }
      let(:inserted) { [ {:id => 1} ]     }

      subject{ insert(expr, inserted) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        context.requests.should eq([ [:insert, :suppliers, inserted] ])
      end

    end
  end
end