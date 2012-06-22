require 'spec_helper'
module Alf
  module Tools
    describe TupleScope, "evaluate" do

      context 'with a simple TupleScope' do
        let(:scope){ TupleScope.new(:a => 1, :b => 2) }

        it "should allow a block" do
          scope.evaluate{ a }.should == 1
        end

        it 'should resolve DUM and DEE correctly' do
          scope.evaluate{ DUM }.should be_a(Relation)
        end
      end

      context 'when scopes are added at construction' do
        let(:scope){ TupleScope.new({:who => "world"}, [ HelpersInScope ]) }

        it 'has available helpers in scope' do
          scope.evaluate{ hello(who) }.should eq("Hello world!")
        end
      end

      context 'when scope has a parent' do
        let(:parent){ Scope.new [ HelpersInScope ] }
        let(:scope){ TupleScope.new({:here => "here"}, [  ], parent) }

        it 'has parent helpers in scope' do
          scope.evaluate{ hello(here) }.should eq("Hello here!")
        end
      end

    end
  end
end
