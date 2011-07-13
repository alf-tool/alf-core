shared_examples_for "A value" do
  
  it "should have a inspect/class.parse that lead to equal values" do
    subject.class.parse(subject.inspect).should eq(subject)
  end
  
  it "should act a valid Hash keys" do
     dup = subject.class.parse(subject.inspect)
     {subject => true, dup => false}.size.should == 1
  end
  
end