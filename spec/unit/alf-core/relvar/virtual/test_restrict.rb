require 'spec_helper'
module Alf
  class Relvar
    describe Virtual, 'restrict' do

      let(:base){
        Relvar.new(examples_database, :suppliers)
      }
      let(:virtual){
        Virtual.new(examples_database, nil, base)
      }

      subject{ virtual.restrict(:city => "London") }

      it 'returns a Relvar' do
        subject.should be_a(Relvar)
      end

      it 'returns a Virtual Relvar' do
        subject.should be_a(Relvar::Virtual)
      end

      it 'bounds the result correctly' do
        subject.expression.should be_a(Operator::Relational::Restrict)
        subject.expression.operand.should eq(base)
      end

    end
  end
end