require 'spec_helper'
module Alf
  module Relvar
    describe Virtual, 'OO relational language' do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:base){ Base.new(expr)                                }
      let(:rv)  { Virtual.new(base)                             }

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

      it 'should have the base relvar as projection operand' do
        subject.expr.operand.should be(base)
      end

    end
  end
end
