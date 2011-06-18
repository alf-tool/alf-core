$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alf'

Alf::Lispy.extend(Alf::Lispy)

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

end
