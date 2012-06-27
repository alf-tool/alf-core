require 'spec_helper'
module Alf
  class Relvar
    describe Memory, "insert" do

      let(:context){ examples_database }

      let(:value){ Relation(:id => [1, 2, 3]) }

      let(:relvar){ Relvar::Memory.new(context, :suppliers, value) }

      subject{
        relvar.insert(arg)
      }

      context 'when passed a Relation' do
        let(:arg){ Relation(:id => [1, 4, 5]) }

        it 'computes insert through a union' do
          subject
          relvar.value.should eq(Relation :id => [1, 2, 3, 4, 5])
        end
      end

      context 'when passed a Relation coercable' do
        let(:arg){ [{ :id => 4}, { :id => 5 }] }

        it 'uses a coerced relation' do
          subject
          relvar.value.should eq(Relation :id => [1, 2, 3, 4, 5])
        end
      end

      context 'when passed a single tuple' do
        let(:arg){ { :id => 4} }

        it 'makes the insert as a singleton relation' do
          subject
          relvar.value.should eq(Relation :id => [1, 2, 3, 4])
        end
      end

    end
  end
end