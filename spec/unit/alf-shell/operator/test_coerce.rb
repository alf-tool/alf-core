require 'spec_helper'
module Alf::Shell::Operator
  describe Coerce do

    let(:input){ suppliers }
    subject{ Coerce.run(argv) }

    before do
      subject.should be_a(Alf::Algebra::Coerce)
      subject.operands.should eq([input])
    end

    context "a typical coercion" do
      let(:argv){ [input] + %w{-- a Integer b Float} }
      specify{
        expected = Alf::Heading[:a => Integer, :b => Float]
        subject.coercions.should eq(expected)
      }
    end

  end
end
