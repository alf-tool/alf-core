require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'qualified_identifier' do
      include Factory

      subject{ qualified_identifier(:t, :name) }

      it_should_behave_like "a predicate AST node"

      it{ should be_a(QualifiedIdentifier) }

      it{ should eql([:qualified_identifier, :t, :name]) }

    end
  end
end
