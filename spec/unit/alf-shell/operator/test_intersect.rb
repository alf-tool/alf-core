require 'spec_helper'
module Alf::Shell::Operator
  describe Intersect do

    let(:left) { suppliers }
    let(:right){ suppliers }
    subject{ Intersect.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Algebra::Intersect)
        subject.operands.should eq([left, right])
      }
    end

  end
end
