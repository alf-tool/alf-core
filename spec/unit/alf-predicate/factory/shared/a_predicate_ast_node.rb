require 'spec_helper'
module Alf
  module Predicate
    shared_examples_for "a predicate AST node" do

      it{ should be_a(Sexpr) }
      it{ should be_a(Predicate) }

    end
  end
end
