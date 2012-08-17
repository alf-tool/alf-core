require 'spec_helper'
module Alf
  module Algebra
    describe Union do

      let(:operator_class){ Union }

      it_should_behave_like("An operator class")

      subject{ a_lispy.union([], []) }

      it { should be_a(Union) }

    end
  end
end
