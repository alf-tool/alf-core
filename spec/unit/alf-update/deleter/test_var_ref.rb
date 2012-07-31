require 'update_helper'
module Alf
  module Update
    describe Deleter, 'var_ref' do

      let(:expr)     { suppliers            }
      let(:inserted) { [ {:id => 1} ]       }
      let(:predicate){ Predicate.eq(:id, 1) }

      subject{ delete(expr, predicate) }

      it 'requests the deletion of the tuples on :suppliers' do
        subject
        db_context.requests.should eq([ [:delete, :suppliers, predicate] ])
      end

    end
  end
end