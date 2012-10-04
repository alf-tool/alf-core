require 'spec_helper'
module Alf
  module Algebra
    describe Unwrap do

      let(:operator_class){ Unwrap }

      it_should_behave_like("An operator class")

      subject{ a_lispy.unwrap(an_operand, :wrapped) }

      it { should be_a(Unwrap) }

    end
  end
end
