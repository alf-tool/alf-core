require_relative 'shared/a_predicate_ast_node'
module Alf
  module Predicate
    describe Factory, 'var_ref' do
      include Factory

      subject{ var_ref(:name) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(VarRef) }
      it{ should eql([:var_ref, :name]) }

    end
  end
end
