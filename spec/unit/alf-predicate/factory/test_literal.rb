require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'literal' do
      include Factory

      subject{ literal(12) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Literal) }
      it{ should eql([:literal, 12]) }

    end
  end
end
