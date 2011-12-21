require 'spec_helper'
module Alf::Shell::Operator
  describe Join do

    let(:left) { [{:left  => true}] }
    let(:right){ [{:right => true}] }
    subject{ Join.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Operator::Relational::Join)
        subject.operands.should eq([left, right])
      }
    end

  end
end
