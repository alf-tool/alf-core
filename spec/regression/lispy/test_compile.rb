require 'spec_helper'
describe "Lispy.compile" do
  
  it "should use a clean binding" do
    p = Alf::Lispy.compile("lambda{ path }", "a path")
    lambda{ p.call }.should raise_error(NameError)
  end
  
  it "should resolve __FILE__ correctly" do
    p = Alf::Lispy.compile("__FILE__", "a path")
    p.should == "a path"
  end
  
end