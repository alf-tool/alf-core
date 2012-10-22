require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "insert" do

      let(:rv)        { Virtual.new(expr, connection)                 }
      let(:expr)      { Algebra.named_operand(:suppliers, connection) }
      let(:tuples)    { Relation.coerce(:id => 1)                     }
      let(:connection){ self                                          }

      def insert(*args)
        @seen = args
      end

      def relvar(name)
        Relvar::Base.new(name, connection)
      end

      subject{ rv.insert(tuples) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, tuples])
      end

    end
  end
end
