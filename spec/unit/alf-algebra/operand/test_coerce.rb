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

      context "on a Hash" do
        let(:arg){ {name: "Jones"} }

        it 'coerces it as a proxy operand on an array' do
          subject.should be_a(Operand::Proxy)
          subject.subject.should eq([ arg ])
        end

        it{ should_not be_bound }
      end

      context "on a Tuple" do
        let(:arg){ Tuple(name: "Jones") }

        it 'coerces it as a proxy operand on an array' do
          subject.should be_a(Operand::Proxy)
          subject.subject.should eq([ arg ])
        end

        it{ should_not be_bound }
      end

    end
  end
end