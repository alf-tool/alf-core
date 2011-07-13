$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'alf'

Alf::Lispy.extend(Alf::Lispy)

def rel(*args)
  Alf::Relation.coerce(args)
end

shared_examples_for "An operator class" do

  it "should not have public set_args, _each and _prepare methods" do
    operator_class.public_method_defined?(:set_args).should be_false
    operator_class.public_method_defined?(:_each).should be_false
    operator_class.public_method_defined?(:_prepare).should be_false
  end

  it "should have a public run method" do
    operator_class.public_method_defined?(:run).should be_true
  end
  
  it "should have a public pipe method" do
    operator_class.public_method_defined?(:pipe).should be_true
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
  
  it "should implement unary? and binary? accurately" do
    operator_class.unary?.should_not eq(operator_class.binary?)
    operator_class.unary?.should eq(operator_class.ancestors.include?(Alf::Operator::Unary))
    operator_class.binary?.should eq(operator_class.ancestors.include?(Alf::Operator::Binary))
  end

end

shared_examples_for "A value" do
  
  it "should have a inspect/class.parse that lead to equal values" do
    subject.class.parse(subject.inspect).should eq(subject)
  end
  
  it "should act a valid Hash keys" do
     dup = subject.class.parse(subject.inspect)
     {subject => true, dup => false}.size.should == 1
  end
  
end
