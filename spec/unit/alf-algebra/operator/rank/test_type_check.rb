require 'type_check_helper'
module Alf
  module Algebra
    describe Rank, 'type_check' do

      subject{ op.type_check }

      context 'when ok' do
        let(:op){ 
          rank(suppliers, [[:name, :asc]], :rank)
        }

        it{ should eq(op.heading) }
      end

      context 'when invalid ordering' do
        let(:op){ 
          rank(suppliers, [[:foo, :asc]], :rank)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /no such attribute `foo`/)
        end
      end

      context 'when name clash' do
        let(:op){ 
          rank(suppliers, [[:name, :asc]], :name)
        }

        it 'should raise an error' do
          lambda{
            subject
          }.should raise_error(TypeCheckError, /cannot override `name`/)
        end
      end

    end
  end
end
