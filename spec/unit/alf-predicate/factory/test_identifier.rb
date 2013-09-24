require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'identifier' do
      include Factory

      subject{ identifier(:name) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Identifier) }
      it{ should eql([:identifier, :name]) }

    end
  end
end
