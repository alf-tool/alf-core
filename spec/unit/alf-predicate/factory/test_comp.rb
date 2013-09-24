require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'comp' do

      subject{ Factory.comp(:eq, h) }

      context "when the hash is empty" do
        let(:h){ {} }

        it{ should eq(Factory.tautology) }
      end

      context "when the hash is singleton" do
        let(:h){ {:x => 12, :y => :z} }
        let(:expected){
          [:and,
            [:eq, [:identifier, :x], [:literal, 12]],
            [:eq, [:identifier, :y], [:identifier, :z]]]
        }

        it_should_behave_like "a predicate AST node"
        it{ should be_a(And) }
        it{ should eq(expected) }
      end

      context "when the hash is not singelton" do
        let(:h){ {:x => 12} }

        it_should_behave_like "a predicate AST node"
        it{ should be_a(Eq) }
        it{ should eq([:eq, [:identifier, :x], [:literal, 12]]) }
      end

    end
  end
end
