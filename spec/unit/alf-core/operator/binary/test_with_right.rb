require 'spec_helper'
module Alf
  describe Operator::Binary, "with_right" do

    let(:operand_1){ [ {:id => 1 } ] }
    let(:operand_2){ [ {:id => 2 } ] }
    let(:operand_3){ [ {:id => 3 } ] }
    let(:operator) { a_lispy.union(operand_1, operand_2) }

    subject{ operator.with_right(operand_3) }

    it{ should be_a(Operator::Relational::Union) }

    specify{
      subject.left.should eq(operand_1)
      subject.right.should eq(operand_3)
    }

    specify{
      operator.left.should eq(operand_1)
      operator.right.should eq(operand_2)
    }

  end
end
