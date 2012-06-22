require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle, "evaluate" do

      let(:handle){ TupleHandle.new }

      before{ handle.__set_tuple(:a => 1, :b => 2) }

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
  end
end
