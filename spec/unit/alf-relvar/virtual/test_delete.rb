require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, "delete" do

      let(:rv)        { Virtual.new(expr, connection)                 }
      let(:expr)      { Algebra.named_operand(:suppliers, connection) }
      let(:connection){ self                                          }

      def delete(*args)
        @seen = args
      end

      def relvar(name)
        Relvar::Base.new(name, connection)
      end

      context 'with a predicate' do
        let(:predicate) { Predicate.eq(:sid, 1) }

        subject{ rv.delete(predicate) }

        it 'delegates the call to the connection' do
          subject
          @seen.should eq([:suppliers, predicate])
        end
      end

      context 'without predicate' do

        subject{ rv.delete }

        it 'uses a tautology' do
          subject
          @seen.should eq([:suppliers, Predicate.tautology])
        end
      end

    end
  end
end
