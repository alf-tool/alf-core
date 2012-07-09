shared_examples_for "An operator class" do

  it "should have a public rubycase_name method" do
    operator_class.should respond_to(:rubycase_name)
  end

  it "should have an arity class method" do
    operator_class.should respond_to(:arity)
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

  it "should have relational? and non_relational? methods" do
    operator_class.should respond_to(:relational?)
    operator_class.should respond_to(:non_relational?)
  end

  it "arity should be consistent with nullary?, unary?, binary?" do
    case operator_class.arity
    when 0
      operator_class.should be_nullary
    when 1
      operator_class.should be_unary
    when 2
      operator_class.should be_binary
    else
      raise "Unexpected arity #{operator_class.arity} (#{operator_class})"
    end
  end

  it "should implement unary? and binary? consistently" do
    op = operator_class
    (op.nullary? || op.unary? || op.binary?).should be_true
    (op.nullary? && op.unary?).should be_false
    (op.nullary? && op.binary?).should be_false
    (op.unary? && op.binary?).should be_false
  end

end
