require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, ".coerce" do

      subject{ Predicate.coerce(arg) }

      describe "from Predicate" do
        let(:arg){ Predicate.new(Factory.tautology) }

        it{ should be(arg) }
      end

      describe "from true" do
        let(:arg){ true }

        specify{
          subject.expr.should be_a(Tautology)
        }
      end

      describe "from false" do
        let(:arg){ false }

        specify{
          subject.expr.should be_a(Contradiction)
        }
      end

      describe "from Symbol" do
        let(:arg){ :status }

        specify{
          subject.expr.should be_a(VarRef)
          subject.expr.var_name.should eq(arg)
        }
      end

      describe "from Proc" do
        let(:arg){ lambda{ status == 10 } }

        specify{
          subject.expr.should be_a(Native)
          subject.to_proc.should be(arg)
        }
      end

      describe "from String" do
        let(:arg){ "status == 10" }

        specify{
          subject.expr.should be_a(Native)
          subject.to_proc.to_ruby_literal.should eq("lambda{ status == 10 }")
        }
      end

      describe "from Hash (single)" do
        let(:arg){ {status: 10} }

        specify{
          subject.expr.should be_a(Eq)
          subject.expr.should eq([:eq, [:var_ref, :status], [:literal, 10]])
        }
      end

      describe "from Tuple (single)" do
        let(:arg){ Tuple(status: 10) }

        specify{
          subject.expr.should be_a(Eq)
          subject.expr.should eq([:eq, [:var_ref, :status], [:literal, 10]])
        }
      end

      describe "from Hash (multiple)" do
        let(:arg){ {status: 10, name: "Jones"} }

        specify{
          subject.should eq(Predicate.eq(status: 10) & Predicate.eq(name: "Jones"))
        }
      end

      describe "from Tuple (multiple)" do
        let(:arg){ Tuple(status: 10, name: "Jones") }

        specify{
          subject.should eq(Predicate.eq(status: 10) & Predicate.eq(name: "Jones"))
        }
      end

      describe "from Relation::DUM" do
        let(:arg){ Relation::DUM }

        specify{
          subject.should eq(Predicate.contradiction)
        }
      end

      describe "from Relation::DEE" do
        let(:arg){ Relation::DEE }

        specify{
          subject.should eq(Predicate.tautology)
        }
      end

      describe "from Relation (arity=1)" do
        let(:arg){ Relation(status: [10, 20]) }

        specify{
          subject.should eq(Predicate.in(:status, [10, 20]))
        }
      end

      describe "from Relation (arity>1)" do
        let(:arg){ Relation([
          {status: 1, city: "London"},
          {status: 2, city: "Paris"}
        ]) }
        let(:expected){
          Predicate.eq({status: 1, city: "London"}) | Predicate.eq({status: 2, city: "Paris"})
        }

        specify{
          subject.should eq(expected)
        }
      end

    end
  end
end