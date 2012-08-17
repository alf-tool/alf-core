require 'spec_helper'
module Alf
  module Algebra
    describe Rank do

      let(:operator_class){ Rank }

      it_should_behave_like("An operator class")

      subject{ a_lispy.rank([], [:weight]) }

      it{ should be_a(Rank) }

    end
  end
end
