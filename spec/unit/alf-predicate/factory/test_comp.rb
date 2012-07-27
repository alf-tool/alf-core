require_relative 'shared/a_predicate_ast_node'
module Alf
  class Predicate
    describe Factory, 'comp' do

      subject{ Factory.comp(:eq, h) }

      context "when the hash is not empty" do
        let(:h){ {:x => 12} }

        it_should_behave_like "a predicate AST node"
        it{ should be_a(Comp) }
        it{ should eq([:comp, :eq, {:x => 12}]) }
      end

      context "when the hash is empty" do
        let(:h){ {} }

        it{ should eq(Factory.tautology) }
      end

    end
  end
end
