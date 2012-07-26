require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'native' do
      include Factory

      let(:proc){ lambda{} }
      subject{ native(proc) }

      it_should_behave_like "a predicate AST node"
      it{ should be_a(Native) }
      it{ should eql([:native, proc]) }

    end
  end
end
