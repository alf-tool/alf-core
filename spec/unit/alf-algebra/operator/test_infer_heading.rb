require 'spec_helper'
module Alf
  module Algebra
    describe InferHeading do

      let(:operator_class){ InferHeading }

      it_should_behave_like("An operator class")

      subject{ a_lispy.infer_heading(an_operand) }

      it{ should be_a(InferHeading) }

    end
  end
end
