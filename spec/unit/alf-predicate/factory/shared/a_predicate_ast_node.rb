require 'spec_helper'
module Alf
  class Predicate
    shared_examples_for "a predicate AST node" do

      it{ should be_a(Sexpr) }
      it{ should be_a(Expr) }

    end
  end
end
