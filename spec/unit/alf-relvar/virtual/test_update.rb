require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "update" do

      let(:rv)        { Virtual.new(expr, connection)                 }
      let(:expr)      { Algebra.named_operand(:suppliers, connection) }
      let(:updating)  { {sname: 'Jones'}                 }
      let(:predicate) { Predicate.eq(:sid, 1)            }
      let(:connection){ self                             }

      def update(*args)
        @seen = args
      end

      def relvar(name)
        Relvar::Base.new(name, connection)
      end

      subject{ rv.update(updating, predicate) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, updating, predicate])
      end

    end
  end
end
