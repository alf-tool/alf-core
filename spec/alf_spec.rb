require 'spec_helper'
describe Alf do
  
  it "should have a version number" do
    Alf.const_defined?(:VERSION).should be_true
  end
  
  it "should allow running a commandline like command" do
    lispy = Alf.lispy(Alf::Environment.examples)
    op = lispy.run(['restrict', 'suppliers', '--', "city == 'London'"])
    op.should be_a(Alf::Operator)
    op.to_a.should == [
      {:status => 20, :sid=>"S1", :name=>"Smith", :city=>"London"},
      {:status => 20, :sid=>"S4", :name=>"Clark", :city=>"London"}
    ]
  end

end
