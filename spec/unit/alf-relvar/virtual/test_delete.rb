require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "delete" do

      let(:rv)        { Virtual.new(connection, expr)                 }
      let(:expr)      { Algebra.named_operand(:suppliers, connection) }
      let(:predicate) { Predicate.eq(:sid, 1)                         }
      let(:connection){ self                                          }

      def delete(*args)
        @seen = args
      end

      def relvar(name)
        Relvar::Base.new(connection, name)
      end

      subject{ rv.delete(predicate) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, predicate])
      end

    end
  end
end
