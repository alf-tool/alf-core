require 'spec_helper'
module Alf
  class Predicate
    describe Grammar, "sexpr" do

      subject{ Grammar.sexpr(expr) }

      let(:contradiction){
        [:contradiction, false]
      }
      let(:var_ref){
        [:var_ref, :name]
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

      describe "var_ref" do
        let(:expr){ [:var_ref, :name] }

        it{ should be_a(VarRef) }
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

      describe "comp" do
        let(:expr){ [:comp, :eq, {:x => 2}] }

        it{ should be_a(Comp) }
      end

      describe "eq" do
        let(:expr){ [:eq, var_ref, var_ref] }

        it{ should be_a(Eq) }
      end

      describe "neq" do
        let(:expr){ [:neq, var_ref, var_ref] }

        it{ should be_a(Neq) }
      end

      describe "gt" do
        let(:expr){ [:gt, var_ref, var_ref] }

        it{ should be_a(Gt) }
      end

      describe "gte" do
        let(:expr){ [:gte, var_ref, var_ref] }

        it{ should be_a(Gte) }
      end

      describe "lt" do
        let(:expr){ [:lt, var_ref, var_ref] }

        it{ should be_a(Lt) }
      end

      describe "lte" do
        let(:expr){ [:lte, var_ref, var_ref] }

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
