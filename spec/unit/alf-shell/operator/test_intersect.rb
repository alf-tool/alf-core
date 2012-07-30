require 'spec_helper'
module Alf::Shell::Operator
  describe Intersect do

    let(:left) { suppliers_var_ref }
    let(:right){ suppliers_var_ref }
    subject{ Intersect.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Operator::Relational::Intersect)
        subject.operands.should eq([left, right])
      }
    end

  end
end
