require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, "factory methods" do

      before do
        subject.should be_a(Predicate)
        subject.expr.should be_a(Expr)
      end

      context "tautology" do
        subject{ Predicate.tautology }

        specify{ subject.to_ruby_code.should eq("true") }
      end

      context "contradiction" do
        subject{ Predicate.contradiction }

        specify{ subject.to_ruby_code.should eq("false") }
      end

      context "var_ref" do
        subject{ Predicate.var_ref(:x) }

        specify{ subject.to_ruby_code.should eq("x") }
      end

      context "eq" do
        subject{ Predicate.eq(:x, 2) }

        specify{ subject.to_ruby_code.should eq("x == 2") }
      end

      context "neq" do
        subject{ Predicate.neq(:x, 2) }

        specify{ subject.to_ruby_code.should eq("x != 2") }
      end

      context "lt" do
        subject{ Predicate.lt(:x, 2) }

        specify{ subject.to_ruby_code.should eq("x < 2") }
      end

      context "lte" do
        subject{ Predicate.lte(:x, 2) }

        specify{ subject.to_ruby_code.should eq("x <= 2") }
      end

      context "gt" do
        subject{ Predicate.gt(:x, 2) }

        specify{ subject.to_ruby_code.should eq("x > 2") }
      end

      context "gte" do
        subject{ Predicate.gte(:x, 2) }

        specify{ subject.to_ruby_code.should eq("x >= 2") }
      end

      context "literal" do
        subject{ Predicate.literal(2) }

        specify{ subject.to_ruby_code.should eq("2") }
      end

      context "native" do
        subject{ Predicate.native(lambda{}) }

        specify{ subject.expr.should be_a(Native) }
      end

    end
  end
end