require 'spec_helper'
module Alf
  class Relvar
    describe Memory, "affect" do

      let(:context){ examples_database }

      let(:relvar){ Relvar::Memory.new(context, :suppliers) }

      subject{
        relvar.affect(arg)
      }

      describe 'when a relation already' do
        let(:arg){ Relation(:id => 1) }

        it 'should return the value' do
          subject.should eq(arg)
        end

        it 'should truly affect it' do
          subject
          relvar.value.should eq(arg)
        end
      end

      describe 'when something coercable to a relation' do
        let(:arg){ [:id => 1] }
        let(:value){ Relation(:id => 1) }

        it 'should return the coerced value' do
          subject.should eq(value)
        end

        it 'should truly affect it' do
          subject
          relvar.value.should eq(value)
        end
      end

    end
  end
end