require 'spec_helper'
module Alf
  module Lang
    describe Lispy, 'connection!' do

      context 'when bound' do
        let(:lispy){ Lispy.new([], 12) }

        it 'allows obtaining its connection' do
          lispy.connection!.should eq(12)
        end
      end

      context 'when unbound' do
        let(:lispy){ Lispy.new }

        it 'raises when connection is used without being bound' do
          lambda{
            lispy.connection!
          }.should raise_error(UnboundError)
        end
      end

    end
  end
end
