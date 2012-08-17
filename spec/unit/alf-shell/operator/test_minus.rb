require 'spec_helper'
module Alf::Shell::Operator
  describe Minus do

    let(:left) { suppliers }
    let(:right){ suppliers }
    subject{ Minus.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Algebra::Minus)
        subject.operands.should eq([left, right])
      }
    end

  end
end
