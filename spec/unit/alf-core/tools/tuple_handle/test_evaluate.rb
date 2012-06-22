require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle, "evaluate" do

      context 'with a simple TupleHandle' do
        let(:handle){ TupleHandle.new(:a => 1, :b => 2) }

        it "should allow a block" do
          handle.evaluate{ a }.should == 1
        end

        it 'should resolve DUM and DEE correctly' do
          handle.evaluate{ DUM }.should be_a(Relation)
        end
      end

      context 'when scopes are added at construction' do
        let(:handle) { TupleHandle.new({:who => "world"}, [ HelpersInScope ]) }

        it 'has available helpers in scope' do
          handle.evaluate{ hello(who) }.should eq("Hello world!")
        end
      end

    end
  end
end
