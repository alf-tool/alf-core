require 'spec_helper'
module Alf::Shell::Operator
  describe Restrict do

    let(:input){ [] }
    subject{ Restrict.run(argv) }

    before do
      subject.should be_a(Alf::Operator::Relational::Restrict)
      subject.operands.should eq([input])
    end

    context "without arg" do
      let(:argv){ [input] }
      specify{
        subject.predicate.should eq(Alf::TuplePredicate[true])
      }
    end

    context "with a single arg" do
      let(:argv){ [ input ] + ["--", "status > 10"] }
      specify{
        subject.predicate.should eq(Alf::TuplePredicate["status > 10"])
      }
    end

    context "with two args" do
      let(:argv){ [ input ] + ["--", "status", "10"] }
      specify{
        subject.predicate.should eq(Alf::TuplePredicate["(self.status == 10)"])
      }
    end

  end
end
