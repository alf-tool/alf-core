require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle, "evaluate" do

      context 'with a simple TupleHandle' do
        let(:handle){ TupleHandle.new(:a => 1, :b => 2) }

        it "should allow a String" do
          handle.evaluate("a").should == 1
        end

        it "should allow a Symbol" do
          handle.evaluate(:a).should == 1
        end

        it "should allow a Proc" do
          handle.evaluate(lambda{ a }).should == 1
        end

        it "should allow a block" do
          handle.evaluate{ a }.should == 1
        end
      end

      context 'when scopes are added at construction' do
        let(:helpers){ Module.new{ def upcase(who); who.upcase; end } }
        let(:handle) { TupleHandle.new({:who => "world"}, helpers)    }

        it 'has available helpers in scope' do
          handle.evaluate{ upcase(who) }.should eq("WORLD")
        end
      end

    end
  end
end
