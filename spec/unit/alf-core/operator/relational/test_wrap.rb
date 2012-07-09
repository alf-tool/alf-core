require 'spec_helper'
module Alf
  module Operator::Relational
    describe Wrap do

      let(:operator_class){ Wrap }

      it_should_behave_like("An operator class")

      subject{ a_lispy.wrap([], [:a, :b], :wraped) }

      it { should be_a(Wrap) }

    end
  end
end
