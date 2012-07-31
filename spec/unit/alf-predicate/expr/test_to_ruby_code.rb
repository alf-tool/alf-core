require 'spec_helper'
module Alf
  class Predicate
    describe Expr, "to_ruby_code" do

      let(:f){ Factory }

      subject{ expr.to_ruby_code }

      after do
        unless expr.is_a?(Native)
          lambda{
            eval "lambda{ #{subject} }"
          }.should_not raise_error
        end
      end

      context 'tautology' do
        let(:expr){ f.tautology }

        it{ should eq("true") }
      end

      context 'contradiction' do
        let(:expr){ f.contradiction }

        it{ should eq("false") }
      end

      describe "var_ref" do
        let(:expr){ f.var_ref(:name) }

        it{ should eq("name") }
      end

      describe "and" do
        let(:expr){ f.and(f.contradiction, f.contradiction) }

        it{ should eq("false && false") }
      end

      describe "or" do
        let(:expr){ f.or(f.contradiction, f.contradiction) }

        it{ should eq("false || false") }
      end

      describe "not" do
        let(:expr){ f.not(f.contradiction) }

        it{ should eq("!false") }
      end

      describe "comp" do
        let(:expr){ f.comp(:lt, {:x => 2}) }

        it{ should eq("x < 2") }
      end

      describe "eq" do
        let(:expr){ f.eq(:x, 2) }

        it{ should eq("x == 2") }
      end

      describe "eq (parentheses required)" do
        let(:expr){ f.eq(f.eq(:y, 2), true) }

        it{ should eq("(y == 2) == true") }
      end

      describe "comp (multiple)" do
        let(:expr){ f.comp(:eq, :x => 2, :y => 3) }

        it{ should eq("(x == 2) && (y == 3)") }
      end

      describe "in" do
        let(:expr){ f.in(:x, [2, 3]) }

        it{ should eq("[2, 3].include?(x)") }
      end

      describe "neq" do
        let(:expr){ f.neq(:x, 2) }

        it{ should eq("x != 2") }
      end

      describe "gt" do
        let(:expr){ f.gt(:x, 2) }

        it{ should eq("x > 2") }
      end

      describe "gte" do
        let(:expr){ f.gte(:x, 2) }

        it{ should eq("x >= 2") }
      end

      describe "lt" do
        let(:expr){ f.lt(:x, 2) }

        it{ should eq("x < 2") }
      end

      describe "lte" do
        let(:expr){ f.lte(:x, 2) }

        it{ should eq("x <= 2") }
      end

      describe "literal" do
        let(:expr){ f.literal(12) }

        it{ should eq("12") }
      end

      describe "native" do
        let(:expr){ f.native(lambda{}) }

        specify{
          lambda{ subject }.should raise_error(NotSupportedError)
        }
      end

      describe "conjunction of two eqs" do
        let(:expr){
          f.and(f.eq(:x, 2), f.eq(:y, 3))
        }

        it{ should eq("(x == 2) && (y == 3)") }
      end

      describe "conjunction of two comps" do
        let(:expr){
          f.and(f.comp(:eq, :x => 2), f.comp(:eq, :y => 3))
        }

        it{ should eq("(x == 2) && (y == 3)") }
      end

      describe "or and and" do
        let(:expr){
          f.and(f.eq(:x, 2), f.or(true, false))
        }

        it{ should eq("(x == 2) && (true || false)") }
      end

    end
  end
end
