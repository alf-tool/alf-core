require 'spec_helper'
module Alf
  describe Operator, "with_operands" do

    let(:operand_1){ [ {:id => 1 } ] }
    let(:operand_2){ [ {:id => 2 } ] }
    let(:extension){ TupleComputation.coerce({:big => "tested > 10"}) }

    let(:operator) { a_lispy.extend(operand_1, extension) }

    subject{ operator.with_operands(operand_2) }

    it{ should be_a(Operator::Relational::Extend) }

    specify{
      subject.operands.should eq([ operand_2 ])
      subject.ext.should be(extension)
    }

    specify{
      operator.operands.should eq([ operand_1 ])
      operator.ext.should be(extension)
    }

  end
end
