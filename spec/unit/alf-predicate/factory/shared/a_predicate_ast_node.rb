require 'spec_helper'
shared_examples_for "a predicate AST node" do

  it{ should be_a(Sexpr) }

  it{ should be_a(Alf::Predicate::Expr) }

  specify{
    (subject.tautology? == subject.is_a?(Alf::Predicate::Tautology)).should be_true
  }

  specify{
    (subject.contradiction? == subject.is_a?(Alf::Predicate::Contradiction)).should be_true
  }

  specify{
    subject.free_variables.should be_a(Alf::AttrList) unless subject.is_a?(Alf::Predicate::Native)
  }

end
