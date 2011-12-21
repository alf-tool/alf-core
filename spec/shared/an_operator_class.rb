shared_examples_for "An operator class" do

  it "should not have public _each and _prepare methods" do
    operator_class.public_method_defined?(:_each).should be_false
    operator_class.public_method_defined?(:_prepare).should be_false
  end

  it "should have a public rubycase_name method" do
    operator_class.should respond_to(:rubycase_name)
  end
  
  it "should have a public each method" do
    operator_class.public_method_defined?(:each).should be_true
  end
  
  it "should have a unary? class method" do
    operator_class.should respond_to(:unary?)
  end

  it "should have a binary? class method" do
    operator_class.should respond_to(:binary?)
  end
  
  it "should have a nullary? class method" do
    operator_class.should respond_to(:nullary?)
  end
  
  it "should implement unary? and binary? accurately" do
    op = operator_class
    (op.nullary? || op.unary? || op.binary?).should be_true
    (op.nullary? && op.unary?).should be_false
    (op.nullary? && op.binary?).should be_false
    (op.unary? && op.binary?).should be_false
  end

end
