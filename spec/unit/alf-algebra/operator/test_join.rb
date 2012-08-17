require 'spec_helper'
module Alf
  module Algebra
    describe Join do

      let(:operator_class){ Join }

      it_should_behave_like("An operator class")

      subject{ a_lispy.join([], []) }

      it { should be_a(Join) }

    end
  end
end
