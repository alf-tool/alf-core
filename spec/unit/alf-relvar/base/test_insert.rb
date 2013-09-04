require 'spec_helper'
module Alf
  module Relvar
    describe Base, "insert" do

      let(:expr)  { Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)    { Base.new(expr)                                }
      let(:tuples){ Relation.coerce(:id => 1)                     }

      def insert(*args)
        @seen = args
      end

      subject{ rv.insert(tuples) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, tuples])
      end

    end
  end
end
