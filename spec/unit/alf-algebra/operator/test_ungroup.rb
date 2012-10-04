require 'spec_helper'
module Alf
  module Algebra
    describe Ungroup do

      let(:operator_class){ Ungroup }

      it_should_behave_like("An operator class")

      subject{ a_lispy.ungroup(an_operand, :as) }

      it { should be_a(Ungroup) }

    end
  end
end
