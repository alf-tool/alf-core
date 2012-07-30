require 'spec_helper'
module Alf::Shell::Operator
  describe Extend do

    let(:input){ suppliers_var_ref }
    subject{ Extend.run(argv) }

    before do
      subject.should be_a(Alf::Operator::Relational::Extend)
      subject.operands.should eq([input])
    end

    context "a typical config" do
      let(:argv){ [input] + %w{-- big} + ["tested > 10"] }
      specify{
        subject.ext.should eq(Alf::TupleComputation[:big => Alf::TupleExpression["tested > 10"]])
      }
    end

  end
end
