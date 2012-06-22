require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle do

      let(:handle){ TupleHandle.new }

      it "should install methods properly" do
        handle.__set_tuple(:hello => "a", :world => "b")
        handle.respond_to?(:hello).should be_true
        handle.respond_to?(:world).should be_true
      end

      it "should behave correctly" do
        handle.__set_tuple(:hello => "a", :world => "b")
        handle.hello.should == "a"
        handle.world.should == "b"
        handle.__set_tuple(:hello => "c", :world => "d")
        handle.hello.should == "c"
        handle.world.should == "d"
      end

      it "should allow instance evaluating on exprs" do
        handle.__set_tuple(:tested => 1)
        handle.evaluate{ tested < 1 }.should be_false
      end

      it "should support an attribute called :path" do
        handle.__set_tuple(:path => 1)
        handle.evaluate{ path < 1 }.should be_false
      end

    end
  end
end
