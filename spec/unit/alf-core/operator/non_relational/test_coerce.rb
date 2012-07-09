require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Coerce do

      let(:operator_class){ Coerce }

      it_should_behave_like("An operator class")

      subject{ a_lispy.coerce([], :a => Integer, :b => Float) }

      it { should be_a(Coerce) }

    end
  end
end
