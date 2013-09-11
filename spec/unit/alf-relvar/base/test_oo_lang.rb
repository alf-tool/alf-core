require 'spec_helper'
module Alf
  module Relvar
    describe Base, 'OO relational language' do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      subject{ rv.project([:sid]) }

      it 'is a relation variable' do
        subject.should be_a(Relvar)
      end

      it 'is a virtual relation variable' do
        subject.should be_a(Relvar::Virtual)
      end

      it 'should have a projection expression' do
        subject.expr.should be_a(Algebra::Project)
      end

      it 'should have the initial expression as projection operand' do
        subject.expr.operand.should be(expr)
      end

    end
  end
end
