require File.expand_path('../spec_helper', __FILE__)
describe Alf do
  
  it "should have a version number" do
    Alf.const_defined?(:VERSION).should be_true
  end
  
end
