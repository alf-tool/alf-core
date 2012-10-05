require 'spec_helper'
module Alf
  module Relvar
    describe Base, "delete" do

      let(:rv)        { Base.new(connection, :suppliers) }
      let(:connection){ self                             }

      def delete(*args)
        @seen = args
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

        it 'uses a tautology predicate' do
          subject
          @seen.should eq([:suppliers, Predicate.tautology])
        end
      end

    end
  end
end
