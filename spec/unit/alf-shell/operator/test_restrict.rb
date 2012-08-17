require 'spec_helper'
module Alf::Shell::Operator
  describe Restrict do

    let(:input){ suppliers }
    subject{ Restrict.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Restrict)
      subject.operands.should eq([input])
    end

    context "without arg" do
      let(:argv){ [input] }
      specify{
        subject.predicate.should eq(Alf::Predicate.coerce(true))
      }
    end

    context "with a single arg" do
      let(:argv){ [ input ] + ["--", "status > 10"] }
      specify{
        subject.predicate.should be_a(Alf::Predicate)
        subject.predicate.to_ruby_code.should eq("status > 10")
      }
    end

    context "with two args" do
      let(:argv){ [ input ] + ["--", "status", "10"] }
      specify{
        subject.predicate.should eq(Alf::Predicate.comp(:eq, :status => 10))
      }
    end

  end
end
