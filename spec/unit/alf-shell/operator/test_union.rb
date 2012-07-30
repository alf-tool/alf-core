require 'spec_helper'
module Alf::Shell::Operator
  describe Union do

    let(:left) { suppliers_var_ref }
    let(:right){ suppliers_var_ref }
    subject{ Union.run(argv) }

    context "the default config" do
      let(:argv){ [left, right] }
      specify{
        subject.should be_a(Alf::Operator::Relational::Union)
        subject.operands.should eq([left, right])
      }
    end

  end
end
