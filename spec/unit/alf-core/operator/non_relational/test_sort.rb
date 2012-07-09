require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Sort do

      let(:operator_class){ Sort }

      it_should_behave_like("An operator class")

      subject{ a_lispy.sort([], [[:first, :asc], [:second, :asc]]) }

      it{ should be_a(Sort) }

    end
  end
end
