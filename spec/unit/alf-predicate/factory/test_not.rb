require_relative 'shared/a_predicate_ast_node'
module Alf
  module Predicate
    describe Factory, 'not' do
      include Factory

      subject{ self.not(true) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Not) }
      it{ should eql([:not, tautology]) }

    end
  end
end
