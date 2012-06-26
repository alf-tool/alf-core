require 'spec_helper'
module Alf
  describe Connection, 'relvar' do

    let(:conn){ examples_database }

    context 'with a name as a Symbol' do
      subject{ conn.relvar(:suppliers) }
      it 'returns a base relation variable' do
        subject.should be_a(Relvar::Base)
      end
      it 'is correctly bound' do
        subject.name.should eq(:suppliers)
        subject.context.should eq(conn)
      end
    end

    context 'with an expression as a String' do
      subject{ conn.relvar("project(:suppliers, [:sid])") }
      it 'returns a virtual relation variable' do
        subject.should be_a(Relvar::Virtual)
      end
      it 'is correctly bound' do
        subject.expression.should be_a(Operator::Relational::Project)
        subject.context.should eq(conn)
      end
    end

    context 'with an expression as a block' do
      subject{ conn.relvar{ project(:suppliers, [:sid]) } }
      it 'returns a virtual relation variable' do
        subject.should be_a(Relvar::Virtual)
      end
      it 'is correctly bound' do
        subject.expression.should be_a(Operator::Relational::Project)
        subject.context.should eq(conn)
      end
    end

    context 'with nothing understandable' do
      it 'raises an error' do
        lambda{
          conn.relvar(nil)
        }.should raise_error(ArgumentError)
      end
    end
  end
end