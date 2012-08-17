require 'spec_helper'
module Alf
  module Support
    describe TupleScope do

      let(:scope){ TupleScope.new }

      it "should install methods properly" do
        scope.__set_tuple(:hello => "a", :world => "b")
        scope.respond_to?(:hello).should be_true
        scope.respond_to?(:world).should be_true
      end

      it "should behave correctly" do
        scope.__set_tuple(:hello => "a", :world => "b")
        scope.hello.should == "a"
        scope.world.should == "b"
        scope.__set_tuple(:hello => "c", :world => "d")
        scope.hello.should == "c"
        scope.world.should == "d"
      end

      it "should allow instance evaluating on exprs" do
        scope.__set_tuple(:tested => 1)
        scope.evaluate{ tested < 1 }.should be_false
      end

      it "should support an attribute called :path" do
        scope.__set_tuple(:path => 1)
        scope.evaluate{ path < 1 }.should be_false
      end

    end
  end
end
