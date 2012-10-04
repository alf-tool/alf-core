require 'spec_helper'
module Alf
  module Algebra
    describe Defaults do

      let(:operator_class){ Defaults }

      it_should_behave_like("An operator class")

      context "--no-strict" do
        subject{ a_lispy.defaults(an_operand, :a => 1, :c => "blue") }

        it{ should be_a(Defaults) }

        it 'is !strict by default' do
          subject.strict.should be_false
        end
      end # --no-strict

      describe "--strict" do
        subject{ a_lispy.defaults(an_operand, {:a => 1, :c => "blue"}, :strict => true) }

        it{ should be_a(Defaults) }

        it 'is strict' do
          subject.strict.should be_true
        end
      end # --strict

    end
  end
end
