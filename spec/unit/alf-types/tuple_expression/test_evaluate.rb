require 'spec_helper'
module Alf
  describe TupleExpression, 'evaluate' do

    subject{ exp.evaluate(scope) }

    let(:tuple){ Tuple(name: "Jones") }

    let(:scope){ Support::TupleScope.new(tuple) }

    context 'when the proc is of arity 0' do
      let(:exp){ TupleExpression[->(){ name.upcase }] }

      it{ should eq("JONES") }
    end

    context 'when the proc is of arity 1' do
      let(:exp){ TupleExpression[->(t){ t.name.upcase }] }

      it{ should eq("JONES") }
    end

    context 'when the proc returns a bound expression' do
      let(:exp){ TupleExpression[->(t){ Algebra::Operand::Named.new(:suppliers, examples_database) }] }

      it{ should be_a(Relation) }
    end

  end # TupleExpression
end # Alf
