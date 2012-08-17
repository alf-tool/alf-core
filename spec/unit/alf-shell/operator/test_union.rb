require 'spec_helper'
module Alf::Shell::Operator
  describe Union do

    let(:left) { suppliers }
    let(:right){ suppliers }
    subject{ Union.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Algebra::Union)
        subject.operands.should eq([left, right])
      }
    end

  end
end
