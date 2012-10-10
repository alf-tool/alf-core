require 'spec_helper'
module Alf
  describe Schema, "NATIVE" do

    subject{ Schema::NATIVE }

    it{ should be_a(Module) }

    it 'converts unknown names as named operands' do
      subject.parse{
        suppliers
      }.should be_a(Algebra::Operand::Named)
    end

  end
end
