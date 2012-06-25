require 'spec_helper'
module Alf
  class Relvar
    describe Virtual, 'initialize' do

      let(:db){ examples_database }

      context 'with a block for the expression' do
        subject{
          Virtual.new(db){ (project :suppliers, [:name]) }
        }
        it 'has no name' do
          subject.name.should be_nil
        end
        it 'has an expression' do
          subject.expression.should be_a(Operator::Relational::Project)
        end
      end

    end
  end
end