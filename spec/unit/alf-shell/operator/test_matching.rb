require 'spec_helper'
module Alf::Shell::Operator
  describe Matching do

    let(:left) { suppliers }
    let(:right){ suppliers }
    subject{ Matching.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Algebra::Matching)
        subject.operands.should eq([left, right])
      }
    end

  end
end
