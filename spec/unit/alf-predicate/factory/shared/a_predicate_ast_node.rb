require 'spec_helper'
module Alf
  class Predicate
    shared_examples_for "a predicate AST node" do

      it{ should be_a(Sexpr) }

      it{ should be_a(Expr) }

      specify{
        (subject.tautology? == subject.is_a?(Tautology)).should be_true
      }

      specify{
        (subject.contradiction? == subject.is_a?(Contradiction)).should be_true
      }

    end
  end
end
