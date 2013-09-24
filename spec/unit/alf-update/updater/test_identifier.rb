require 'update_helper'
module Alf
  module Update
    describe Updater, 'identifier' do

      let(:expr)     { suppliers            }
      let(:updating) { {:city => "London"}  }
      let(:predicate){ Predicate.eq(:id, 1) }

      subject{ update(expr, updating, predicate) }

      it 'requests the insertion of the tuples on :suppliers' do
        subject
        db_context.requests.should eq([ [:update, :suppliers, updating, predicate] ])
      end

    end
  end
end