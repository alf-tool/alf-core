require 'spec_helper'
module Alf
  module Operator::Relational
    describe Restrict do

      let(:operator_class){ Restrict }

      it_should_behave_like("An operator class")

      subject{ a_lispy.restrict([], lambda{ name < 10 }) }

      it { should be_a(Restrict) }

    end
  end
end
