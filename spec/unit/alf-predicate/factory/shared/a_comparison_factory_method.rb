require_relative 'a_predicate_ast_node'
module Alf
  class Predicate
    shared_examples_for "a comparison factory method" do
      include Factory

      context 'with two operands' do
        subject{ self.send(method, true, true) }

        it_should_behave_like "a predicate AST node"
        it{ should be_a(node_class) }
        it{ should eql([method, tautology, tautology]) }
      end

      context 'with a Hash operand (singleton)' do
        subject{ self.send(method, :x => :y) }
        let(:expected){
          [method, [:var_ref, :x], [:var_ref, :y]]
        }

        it_should_behave_like "a predicate AST node"
        it{ should eql(expected) }
      end

      context 'with a Hash operand' do
        subject{ self.send(method, :x => :y, :v => 2) }
        let(:expected){
          [:and,
            [method, [:var_ref, :x], [:var_ref, :y]],
            [method, [:var_ref, :v], [:literal, 2]]]
        }

        it_should_behave_like "a predicate AST node"
        it{ should eql(expected) }
      end

    end
  end
end
