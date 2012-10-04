require 'spec_helper'
module Alf
  module Algebra
    describe Coerce do

      let(:operator_class){ Coerce }

      it_should_behave_like("An operator class")

      subject{ a_lispy.coerce(an_operand, :a => Integer, :b => Float) }

      it { should be_a(Coerce) }

      it 'should be bound correctly' do
        subject.coercions.should eq(Heading[:a => Integer, :b => Float])
      end

    end
  end
end
