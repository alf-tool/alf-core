require 'spec_helper'
module Alf
  module Relvar
    describe Base, 'OO relational language' do

      let(:expr){ Algebra::Operand::Named.new(:suppliers, self) }
      let(:rv)  { Base.new(expr)                                }

      shared_examples_for "the result of a query operator" do
        it 'is a relation variable' do
          subject.should be_a(Relvar)
        end

        it 'is a virtual relation variable' do
          subject.should be_a(Relvar::Virtual)
        end

        it 'should have the initial expression as projection operand' do
          subject.expr.operand.should be(expr)
        end
      end

      context 'on project' do
        subject{ rv.project([:sid]) }

        it_should_behave_like "the result of a query operator"

        it 'should have a projection expression' do
          subject.expr.should be_a(Algebra::Project)
        end
      end

      context 'on allbut' do
        subject{ rv.allbut([:sid]) }

        it_should_behave_like "the result of a query operator"

        it 'should have an allbut expression' do
          subject.expr.should be_a(Algebra::Allbut)
        end
      end

    end
  end
end
