require 'spec_helper'
module Alf
  module Support
    describe TupleScope, "[]" do

      context 'with a simple TupleScope' do
        let(:scope){ TupleScope.new(:a => 1, :b => 2) }

        it "delegates to the tuple" do
          scope[:a].should == 1
        end

        it "return nil on unexisting" do
          scope[:c].should be_nil
        end
      end

    end
  end
end
