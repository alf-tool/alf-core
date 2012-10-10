require 'spec_helper'
module Alf
  module Algebra
    describe Operand, '.coerce' do

      subject{ Operand.coerce(arg) }

      context "on a Symbol" do
        let(:arg){ :suppliers }

        it 'coerces it as a named operand' do
          subject.should be_a(Operand::Named)
          subject.name.should eq(:suppliers)
        end

        it{ should_not be_bound }
      end

    end
  end
end