require 'spec_helper'
module Alf::Shell::Operator
  describe NotMatching do

    let(:left) { suppliers }
    let(:right){ suppliers }
    subject{ NotMatching.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Algebra::NotMatching)
        subject.operands.should eq([left, right])
      }
    end

  end
end
