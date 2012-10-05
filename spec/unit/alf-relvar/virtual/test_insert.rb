require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "insert" do

      let(:rv)        { Virtual.new(connection, expr)                 }
      let(:expr)      { Algebra.named_operand(:suppliers, connection) }
      let(:tuples)    { Relation.new(:id => 1)                        }
      let(:connection){ self                                          }

      def insert(*args)
        @seen = args
      end

      def relvar(name)
        Relvar::Base.new(connection, name)
      end

      subject{ rv.insert(tuples) }

      it 'delegates the call to the connection' do
        subject
        @seen.should eq([:suppliers, tuples])
      end

    end
  end
end
