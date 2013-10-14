require 'spec_helper'
module Alf
  describe Viewpoint, "NATIVE" do

    subject{ Viewpoint::NATIVE }

    it{ should be_a(Module) }

    it 'converts unknown names as named operands' do
      subject.parse{
        suppliers
      }.should be_a(Algebra::Operand::Named)
    end

    it 'should allow being used in a Lispy' do
      Lang::Parser::Lispy.new([subject]).parse{
        suppliers
      }.should be_a(Algebra::Operand::Named)
    end

  end
end
