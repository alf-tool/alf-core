require 'spec_helper'
module Alf::Shell::Operator
  describe Coerce do

    let(:input){ [] }
    subject{ Coerce.run(argv) }

    before do
      subject.should be_a(Alf::Operator::NonRelational::Coerce)
      subject.operands.should eq([input])
    end

    context "a typical coercion" do
      let(:argv){ [input] + %w{-- a Integer b Float} }
      specify{
        subject.heading.should eq(Alf::Heading[:a => Integer, :b => Float])
      }
    end

  end
end
