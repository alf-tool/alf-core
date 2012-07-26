require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'or' do
      include Factory

      subject{ self.or(true, true) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Or) }
      it{ should eql([:or, tautology, tautology]) }

    end
  end
end
