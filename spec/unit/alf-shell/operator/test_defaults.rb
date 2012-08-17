require 'spec_helper'
module Alf::Shell::Operator
  describe Defaults do

    let(:input){ suppliers }
    subject{ Defaults.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Defaults)
      subject.defaults.should eq(Alf::TupleComputation[:a => Alf::TupleExpression["1"], :c => Alf::TupleExpression["'blue'"]])
      subject.operands.should eq([input])
    end

    context "--no-strict" do
      let(:argv){ [input] + %w{-- a 1 c 'blue'} }
      specify{
        subject.strict.should eq(false)
      }
    end

    context "--strict" do
      let(:argv){ [input] + %w{--strict -- a 1 c 'blue'} }
      specify{
        subject.strict.should eq(true)
      }
    end

  end
end
