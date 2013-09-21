require 'spec_helper'
module Alf
  module Support
    describe TupleScope, "to_s and inspect" do

      let(:tuple){ {:a => 1, :b => 2} }

      context 'with a simple TupleScope' do
        let(:scope){ TupleScope.new(tuple) }

        it "delegates to_s to the tuple" do
          scope.to_s.should eq(tuple.to_s)
        end

        it "delegates to the tuple" do
          scope.inspect.should eq(tuple.inspect)
        end
      end

    end
  end
end
