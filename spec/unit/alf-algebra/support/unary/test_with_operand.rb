require 'spec_helper'
module Alf
  module Algebra
    describe Unary, "with_operand" do

      let(:operand_1){ an_operand }
      let(:operand_2){ an_operand }
      let(:extension){ TupleComputation.coerce({:big => "tested > 10"}) }

      let(:operator) { a_lispy.extend(operand_1, extension) }

      subject{ operator.with_operand(operand_2) }

      it{ should be_a(Extend) }

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
end
