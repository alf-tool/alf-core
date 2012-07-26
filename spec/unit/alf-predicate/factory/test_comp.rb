require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'comp' do
      include Factory

      subject{ comp(:eq, :x => 12) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Comp) }
      it{ should eql([:comp, :eq, {:x => 12}]) }

    end
  end
end
