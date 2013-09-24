require 'spec_helper'
module Alf
  class Predicate
    describe Grammar, "sexpr" do

      subject{ Grammar.sexpr(expr) }

      let(:contradiction){
        [:contradiction, false]
      }
      let(:identifier){
        [:identifier, :name]
      }

      before do
        subject.should be_a(Sexpr)
      end

      describe "tautology" do
        let(:expr){ [:tautology, true] }

        it{ should be_a(Tautology) }
      end

      describe "contradiction" do
        let(:expr){ [:contradiction, false] }

        it{ should be_a(Contradiction) }
      end

      describe "identifier" do
        let(:expr){ [:identifier, :name] }

        it{ should be_a(Identifier) }
      end

      describe "and" do
        let(:expr){ [:and, contradiction, contradiction] }

        it{ should be_a(And) }
      end

      describe "or" do
        let(:expr){ [:or, contradiction, contradiction] }

        it{ should be_a(Or) }
      end

      describe "not" do
        let(:expr){ [:not, contradiction] }

        it{ should be_a(Not) }
      end

      describe "eq" do
        let(:expr){ [:eq, identifier, identifier] }

        it{ should be_a(Eq) }
      end

      describe "neq" do
        let(:expr){ [:neq, identifier, identifier] }

        it{ should be_a(Neq) }
      end

      describe "gt" do
        let(:expr){ [:gt, identifier, identifier] }

        it{ should be_a(Gt) }
      end

      describe "gte" do
        let(:expr){ [:gte, identifier, identifier] }

        it{ should be_a(Gte) }
      end

      describe "lt" do
        let(:expr){ [:lt, identifier, identifier] }

        it{ should be_a(Lt) }
      end

      describe "lte" do
        let(:expr){ [:lte, identifier, identifier] }

        it{ should be_a(Lte) }
      end

      describe "literal" do
        let(:expr){ [:literal, 12] }

        it{ should be_a(Literal) }
      end

      describe "native" do
        let(:expr){ [:native, lambda{}] }

        it{ should be_a(Native) }
      end

    end
  end
end
