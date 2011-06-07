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

  end   
end
