require 'spec_helper'
module Alf
  module Operator::Relational
    describe Heading do

      let(:operator_class){ Heading }

      it_should_behave_like("An operator class")

      subject{ a_lispy.heading([]) }

      it{ should be_a(Heading) }

    end
  end
end
