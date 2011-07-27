require 'spec_helper'
module Alf
  module Tools
    describe TupleHandle do
  
      let(:handle){ TupleHandle.new }
  
      it "should install methods properly" do
        handle.set(:hello => "a", :world => "b")
        handle.should respond_to(:hello)
        handle.should respond_to(:world)
      end
  
      it "should behave correctly" do
        handle.set(:hello => "a", :world => "b")
        handle.hello.should == "a"
        handle.world.should == "b"
        handle.set(:hello => "c", :world => "d")
        handle.hello.should == "c"
        handle.world.should == "d"
      end
  
      it "should allow instance evaluating on exprs" do
        handle.set(:tested => 1)
        handle.instance_eval{ tested < 1 }.should be_false
      end
  
      it "should support an attribute called :path" do
        handle.set(:path => 1)
        handle.instance_eval{ path < 1 }.should be_false
      end
    
      describe "evaluate" do
        before{ handle.set(:a => 1, :b => 2) }
        
        it "should allow a String" do
          handle.evaluate("a").should == 1
        end
        
        it "should allow a Symbol" do
          handle.evaluate(:a).should == 1
        end
        
        it "should allow a Proc" do
          handle.evaluate(lambda{ a }).should == 1
        end
        
        it "should allow a Hash" do
          handle.evaluate(:a => 1).should == true
          handle.evaluate(:a => 2).should == false
          handle.evaluate(:a => 1, :b => 1).should == false
          handle.evaluate(:a => 1, :b => 2).should == true
        end
        
        it "should allow an Array" do
          handle.evaluate([:a, 1]).should == true
          handle.evaluate([:a, 2]).should == false
          handle.evaluate([:a, 1, :b, 1]).should == false
          handle.evaluate([:a, 1, :b, 2]).should == true
        end
        
      end
  
    end   
  end
end