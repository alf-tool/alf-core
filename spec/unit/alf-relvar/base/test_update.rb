require 'spec_helper'
module Alf
  module Relvar
    describe Base, "update" do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      let(:updating)  { {sname: 'Jones'}      }
      let(:predicate) { Predicate.eq(:sid, 1) }

      def update(*args)
        @seen = args
      end

      subject{ rv.update(updating, predicate) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, updating, predicate])
      end

    end
  end
end
