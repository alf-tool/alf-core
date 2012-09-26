require 'spec_helper'
module Alf
  describe Shell, ".from_argv(argv, Predicate)" do

    subject{ Shell.from_argv(argv, Predicate) }

    describe "from a singleton Array" do
      let(:argv){ ["status == 10"] }

      specify{
        subject.expr.should be_a(Predicate::Native)
        subject.to_ruby_literal.should eq("lambda{ status == 10 }")
      }
    end

    describe "from an Array with coercion" do
      let(:argv){ ["status", "10"] }

      specify{
        subject.expr.should be_a(Predicate::Eq)
        subject.expr.should eq([:eq, [:var_ref, :status], [:literal, 10]])
      }
    end

  end
end