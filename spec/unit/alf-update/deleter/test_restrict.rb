require 'update_helper'
module Alf
  module Update
    describe Inserter, 'restrict' do

      let(:r_predicate){ Predicate.eq(:name, "Jones")     }
      let(:expr)       { restrict(suppliers, r_predicate) }
      let(:d_predicate){ Predicate.eq(:city, "London")    }
      let(:anded)      { Predicate.eq(:name => "Jones", :city => "London") }

      subject{ delete(expr, d_predicate) }

      it 'requests the delete with a AND predicate' do
        subject
        db_context.requests.should eq([ [:delete, :suppliers, anded ] ])
      end

    end
  end
end