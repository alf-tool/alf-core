require 'spec_helper'
module Alf
  describe Relvar, 'restrict' do

    let(:relvar){ Relvar.new(examples_database, :suppliers) }

    subject{ relvar.restrict(:city => "London") }

    it 'returns a Relvar' do
      subject.should be_a(Relvar)
    end

    it 'returns a Virtual Relvar' do
      subject.should be_a(Relvar::Virtual)
    end

    it 'bounds the result correctly' do
      subject.expression.should be_a(Operator::Relational::Restrict)
      subject.expression.operand.should eq(relvar)
    end

  end
end