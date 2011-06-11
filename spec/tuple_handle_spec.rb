require File.expand_path('../spec_helper', __FILE__)
class Alf
  describe TupleHandle do

    let(:handle){ TupleHandle.new }

    it "should install methods properly" do
      handle.set(:hello => "a", :world => "b")
      handle.should respond_to(:hello)
      handle.should respond_to(:world)
    end

    it "installed methods should behave correctly" do
      handle.set(:hello => "a", :world => "b")
      handle.hello.should == "a"
      handle.world.should == "b"
      handle.set(:hello => "c", :world => "d")
      handle.hello.should == "c"
      handle.world.should == "d"
    end

    it "should allow instance evaluatin on exprs" do
      handle.set(:tested => 1)
      handle.instance_eval{ tested < 1 }.should be_false
    end

    describe "compile" do
      
      it "should return a Proc when passed a string" do
        TupleHandle.compile("true").should be_a(Proc)
      end

      it "should return the Proc when directly passed" do
        x = lambda{ true }
        TupleHandle.compile(x).should == x
      end

    end

    describe "evaluate" do
      before{ handle.set(:a => 1, :b => 2) }
      
      it "should allow a String" do
        handle.evaluate("a").should == 1
      end
      
      it "should allow a Proc" do
        handle.evaluate(lambda{ a }).should == 1
      end

      it "should allow the result of compile" do
        handle.evaluate(TupleHandle.compile('a')).should == 1
      end

    end

  end   
end
