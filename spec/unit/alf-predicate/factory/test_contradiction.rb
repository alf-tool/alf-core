require_relative 'shared/a_predicate_ast_node'
module Alf
  module Predicate
    describe Factory, 'contradiction' do
      include Factory

      subject{ contradiction }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Contradiction) }
    end
  end
end
