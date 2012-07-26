require_relative 'shared/a_predicate_ast_node'
module Alf
  module Predicate
    describe Factory, 'and' do
      include Factory

      subject{ self.and(true, true) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(And) }
      it{ should eql([:and, tautology, tautology]) }

    end
  end
end
