require 'spec_helper' 
describe "__FILE__" do

  describe "when used with eval within same file" do
    let(:src){ "__FILE__" }
    subject{ Kernel.eval(src, binding, __FILE__) }
    it { should == __FILE__ }
  end
  
  describe "when used with eval from other file" do
    let(:src){ "__FILE__" }
    subject{ Kernel.eval(src, binding, "hello.rb") }
    it { should == "hello.rb" }
  end
  
  
end