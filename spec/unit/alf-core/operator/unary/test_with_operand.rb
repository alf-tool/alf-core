require 'spec_helper'
module Alf
  describe Operator::Unary, "with_operand" do

    let(:operand_1){ [ {:id => 1 } ] }
    let(:operand_2){ [ {:id => 2 } ] }
    let(:extension){ TupleComputation.coerce({:big => "tested > 10"}) }

    let(:operator) { a_lispy.extend(operand_1, extension) }

    subject{ operator.with_operand(operand_2) }

    it{ should be_a(Operator::Relational::Extend) }

    specify{
      subject.operand.should eq(operand_2)
      subject.ext.should be(extension)
    }

    specify{
      operator.operand.should eq(operand_1)
      operator.ext.should be(extension)
    }

  end
end
