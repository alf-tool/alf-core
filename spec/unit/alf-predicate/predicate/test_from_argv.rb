require 'spec_helper'
module Alf
  class Predicate
    describe Predicate, ".from_argv" do

      subject{ Predicate.from_argv(argv) }

      describe "from a singleton Array" do
        let(:argv){ ["status == 10"] }

        specify{
          subject.expr.should be_a(Native)
          subject.to_ruby_literal.should eq("lambda{ status == 10 }")
        }
      end
      
      describe "from an Array with coercion" do
        let(:argv){ ["status", "10"] }

        specify{
          subject.expr.should be_a(Eq)
          subject.expr.should eq([:eq, [:var_ref, :status], [:literal, 10]])
        }
      end

    end
  end
end